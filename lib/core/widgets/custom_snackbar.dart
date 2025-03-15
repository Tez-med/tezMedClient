import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';

class AnimatedCustomSnackbar {
  static OverlayEntry? _currentOverlay;

  static void show({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    SnackbarType type = SnackbarType.info,
    Duration animationDuration = const Duration(milliseconds: 500),
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    try {
      final overlayState = Overlay.of(context);

      // Avvalgi snackbarni o'chirish
      _currentOverlay?.remove();
      _currentOverlay = null;

      OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).padding.top +
              10, // StatusBar ostida chiqadi
          left: 16,
          right: 16,
          child: _AnimatedSnackbarContent(
            message: message,
            actionLabel: actionLabel,
            onActionPressed: onActionPressed,
            type: type,
            animationDuration: animationDuration,
            onDismiss: () {
              _currentOverlay?.remove();
              _currentOverlay = null;
            },
          ),
        ),
      );

      _currentOverlay = overlayEntry;
      overlayState.insert(overlayEntry);

      // Belgilangan vaqtdan keyin snackbarni avtomatik o'chirish
      Future.delayed(displayDuration + animationDuration, () {
        if (_currentOverlay == overlayEntry) {
          _currentOverlay?.remove();
          _currentOverlay = null;
        }
      });
    } catch (e) {
      debugPrint('Error showing snackbar: $e');
    }
  }
}

enum SnackbarType { info, success, warning, error }

class _AnimatedSnackbarContent extends StatefulWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final SnackbarType type;
  final Duration animationDuration;
  final VoidCallback onDismiss;

  const _AnimatedSnackbarContent({
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    required this.type,
    required this.animationDuration,
    required this.onDismiss,
  });

  @override
  _AnimatedSnackbarContentState createState() =>
      _AnimatedSnackbarContentState();
}

class _AnimatedSnackbarContentState extends State<_AnimatedSnackbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getGradientColors(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _getShadowColor(),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppTextstyle.nunitoBold
                        .copyWith(fontSize: 16, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _animationController
                        .reverse()
                        .then((_) => widget.onDismiss());
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    switch (widget.type) {
      case SnackbarType.info:
        iconData = Icons.info_outline;
        break;
      case SnackbarType.success:
        iconData = Icons.check_circle_outline;
        break;
      case SnackbarType.warning:
        iconData = Icons.warning_amber_rounded;
        break;
      case SnackbarType.error:
        iconData = Icons.error_outline;
        break;
    }

    return Icon(
      iconData,
      color: Colors.white,
      size: 28,
    );
  }

  List<Color> _getGradientColors() {
    switch (widget.type) {
      case SnackbarType.info:
        return [Colors.blue.shade700, Colors.blue.shade400];
      case SnackbarType.success:
        return [Colors.green.shade700, Colors.green.shade400];
      case SnackbarType.warning:
        return [Colors.orange.shade700, Colors.orange.shade400];
      case SnackbarType.error:
        return [Colors.red.shade700, Colors.red.shade400];
    }
  }

  Color _getShadowColor() {
    switch (widget.type) {
      case SnackbarType.info:
        return Colors.blue.shade300.withValues(alpha: 0.4);
      case SnackbarType.success:
        return Colors.green.shade300.withValues(alpha: 0.4);
      case SnackbarType.warning:
        return Colors.orange.shade300.withValues(alpha: 0.4);
      case SnackbarType.error:
        return Colors.red.shade300.withValues(alpha: 0.4);
    }
  }
}
