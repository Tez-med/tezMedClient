import 'dart:math' show Random, cos, pi, sin;
import 'package:flutter/material.dart';

class UnifiedLoadingAnimation extends StatefulWidget {
  final bool isSuccess;
  final VoidCallback onComplete;
  final LoadingDialogTheme theme;
  final LoadingDialogText text;

  const UnifiedLoadingAnimation({
    super.key,
    required this.isSuccess,
    required this.onComplete,
    this.theme = const LoadingDialogTheme(),
    this.text = const LoadingDialogText(),
  });

  @override
  State<UnifiedLoadingAnimation> createState() =>
      _UnifiedLoadingAnimationState();
}

class LoadingDialogTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final double dialogWidth;
  final double animationSize;
  final EdgeInsets padding;
  final BoxShadow? shadow;
  final Duration animationDuration;
  final BorderRadius borderRadius;

  const LoadingDialogTheme({
    this.primaryColor = const Color(0xFF6C63FF),
    this.secondaryColor = const Color(0xFF8F8AFF),
    this.backgroundColor = Colors.white,
    this.dialogWidth = 280,
    this.animationSize = 160,
    this.padding = const EdgeInsets.all(24),
    this.shadow,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  BoxShadow get defaultShadow =>
      shadow ??
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.15),
        blurRadius: 24,
        spreadRadius: 8,
        offset: const Offset(0, 8),
      );
}

class LoadingDialogText {
  final String loadingTitle;
  final String loadingSubtitle;
  final String successTitle;
  final String successSubtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const LoadingDialogText({
    this.loadingTitle = "Yuklanmoqda...",
    this.loadingSubtitle = "Iltimos kuting",
    this.successTitle = "Muvaffaqiyatli",
    this.successSubtitle = "Amal bajarildi",
    this.titleStyle,
    this.subtitleStyle,
  });

  TextStyle get defaultTitleStyle =>
      titleStyle ??
      const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  TextStyle get defaultSubtitleStyle =>
      subtitleStyle ??
      const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      );
}

class _UnifiedLoadingAnimationState extends State<UnifiedLoadingAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _morphAnimation;
  final List<_Particle> _particles = [];
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateParticles();

    if (widget.isSuccess) {
      Future.delayed(const Duration(milliseconds: 300), _startSuccessAnimation);
    } else {
      _startLoadingAnimation();
    }
  }

  void _generateParticles() {
    final random = Random();
    for (int i = 0; i < 8; i++) {
      final angle = (2 * pi * i) / 8;
      _particles.add(
        _Particle(
          angle: angle,
          radius: 40.0,
          speed: 1 + random.nextDouble() * 0.5,
          size: 8 + random.nextDouble() * 4,
        ),
      );
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.theme.animationDuration,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _morphAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutExpo,
    );
  }

  void _startLoadingAnimation() => _animationController.repeat();

  void _startSuccessAnimation() {
    setState(() => _showSuccess = true);
    _animationController
      ..stop()
      ..reset()
      ..forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: widget.theme.dialogWidth,
        padding: widget.theme.padding,
        decoration: BoxDecoration(
          color: widget.theme.backgroundColor,
          borderRadius: widget.theme.borderRadius,
          boxShadow: [widget.theme.defaultShadow],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimation(),
            const SizedBox(height: 24),
            _buildTexts(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return SizedBox(
      height: widget.theme.animationSize,
      width: widget.theme.animationSize,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: _UnifiedAnimationPainter(
              rotationValue: _rotationAnimation.value,
              scaleValue: _scaleAnimation.value,
              morphValue: _morphAnimation.value,
              particles: _particles,
              showSuccess: _showSuccess,
              primaryColor: widget.theme.primaryColor,
              secondaryColor: widget.theme.secondaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTexts() {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _showSuccess ? widget.text.successTitle : widget.text.loadingTitle,
            key: ValueKey('title_$_showSuccess'),
            style: widget.text.defaultTitleStyle.copyWith(
              color: widget.theme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _showSuccess
                ? widget.text.successSubtitle
                : widget.text.loadingSubtitle,
            key: ValueKey('subtitle_$_showSuccess'),
            style: widget.text.defaultSubtitleStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _Particle {
  final double angle;
  final double radius;
  final double speed;
  final double size;

  const _Particle({
    required this.angle,
    required this.radius,
    required this.speed,
    required this.size,
  });
}

class _UnifiedAnimationPainter extends CustomPainter {
  final double rotationValue;
  final double scaleValue;
  final double morphValue;
  final List<_Particle> particles;
  final bool showSuccess;
  final Color primaryColor;
  final Color secondaryColor;

  const _UnifiedAnimationPainter({
    required this.rotationValue,
    required this.scaleValue,
    required this.morphValue,
    required this.particles,
    required this.showSuccess,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);

    if (!showSuccess) {
      _drawLoadingState(canvas);
    } else {
      _drawTransitionToSuccess(canvas);
    }

    canvas.restore();
  }

  void _drawLoadingState(Canvas canvas) {
    final mainPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    for (var particle in particles) {
      final currentAngle = particle.angle + (rotationValue * particle.speed);
      final offset = Offset(
        cos(currentAngle) * particle.radius * scaleValue,
        sin(currentAngle) * particle.radius * scaleValue,
      );

      canvas.drawCircle(
        offset,
        particle.size * (0.8 + sin(rotationValue * 2) * 0.2),
        mainPaint..color = primaryColor.withValues(alpha: 0.8),
      );

      if (particles.indexOf(particle) > 0) {
        final prevParticle = particles[particles.indexOf(particle) - 1];
        final prevAngle =
            prevParticle.angle + (rotationValue * prevParticle.speed);
        final prevOffset = Offset(
          cos(prevAngle) * prevParticle.radius * scaleValue,
          sin(prevAngle) * prevParticle.radius * scaleValue,
        );

        canvas.drawLine(
          prevOffset,
          offset,
          mainPaint..color = primaryColor.withValues(alpha: 0.3),
        );
      }
    }

    canvas.drawCircle(
      Offset.zero,
      20 * scaleValue,
      mainPaint..color = primaryColor.withValues(alpha: 0.2),
    );
  }

  void _drawTransitionToSuccess(Canvas canvas) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final successPath = Path();
    final scale = 0.8 + (morphValue * 0.2);

    successPath.moveTo(-20 * scale, 0);
    successPath.lineTo(-5 * scale, 15 * scale);
    successPath.lineTo(20 * scale, -15 * scale);

    canvas.drawCircle(
      Offset.zero,
      40 * (1 + morphValue * 0.1),
      paint,
    );

    if (morphValue > 0.3) {
      final progress = ((morphValue - 0.3) / 0.7).clamp(0.0, 1.0);
      final pathMetrics = successPath.computeMetrics().first;
      final extractPath = pathMetrics.extractPath(
        0.0,
        pathMetrics.length * progress,
      );

      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(_UnifiedAnimationPainter oldDelegate) =>
      rotationValue != oldDelegate.rotationValue ||
      scaleValue != oldDelegate.scaleValue ||
      morphValue != oldDelegate.morphValue ||
      showSuccess != oldDelegate.showSuccess;
}
