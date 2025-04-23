import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButtons extends StatelessWidget {
  final Clinic clinic;

  const ContactButtons({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    final socialLinks = [
      if (clinic.instagramLink.isNotEmpty)
        _SocialLink(
          icon: FontAwesomeIcons.instagram,
          text: 'Instagram',
          url: clinic.instagramLink,
          appUri:
              'instagram://user?username=${_extractUsername(clinic.instagramLink)}',
          webUri: clinic.instagramLink,
          color: const Color(0xFFE1306C), // Instagram rang
        ),
      if (clinic.tgLink.isNotEmpty)
        _SocialLink(
          icon: FontAwesomeIcons.telegram,
          text: 'Telegram',
          url: clinic.tgLink,
          appUri: 'tg://resolve?domain=${_extractUsername(clinic.tgLink)}',
          webUri: clinic.tgLink,
          color: const Color(0xFF0088CC), // Telegram rang
        ),
    ];

    if (socialLinks.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: socialLinks.map((link) {
              return _AnimatedContactButton(
                icon: link.icon,
                text: link.text,
                color: link.color,
                onTap: () => _launchApp(link.appUri, link.webUri),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Instagram yoki Telegram URL dan username ajratish
  String _extractUsername(String url) {
    Uri uri = Uri.parse(url);

    // Instagram username ajratish
    if (url.contains('instagram.com')) {
      // instagram.com/username formatidan username olish
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        // Agar yo'l qismi bo'lsa, username qaytariladi
        return pathSegments.first;
      }
    }

    // Telegram username ajratish
    if (url.contains('t.me/')) {
      // t.me/username formatidan username olish
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        // Agar yo'l qismi bo'lsa, username qaytariladi
        return pathSegments.first;
      }
    }

    // Agar username ajratib bo'lmasa, bo'sh string qaytariladi
    return '';
  }

  // Avval ilovani ochishga urinib ko'rish, agar ilova yo'q bo'lsa brauzerda ochish
  Future<void> _launchApp(String appUri, String webUri) async {
    try {
      // Avval app URL sxemasini ochishga urinish
      final appUrl = Uri.parse(appUri);
      final canLaunchApp = await canLaunchUrl(appUrl);

      if (canLaunchApp) {
        // Ilova mavjud, ilovani ochish
        await launchUrl(appUrl);
      } else {
        // Ilova mavjud emas, brauzerda ochish
        final webUrl = Uri.parse(webUri);
        if (await canLaunchUrl(webUrl)) {
          await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch $webUrl');
        }
      }
    } catch (e) {
      // Xato bo'lsa, brauzerda ochishga urinish
      try {
        final webUrl = Uri.parse(webUri);
        if (await canLaunchUrl(webUrl)) {
          await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
    }
  }
}

// Ijtimoiy tarmoq havolasi ma'lumotlar modeli
class _SocialLink {
  final IconData icon;
  final String text;
  final String url;
  final String appUri; // Ilova uchun URI (instagram://, tg:// kabi)
  final String webUri; // Brauzer uchun URI
  final Color color;

  const _SocialLink({
    required this.icon,
    required this.text,
    required this.url,
    required this.appUri,
    required this.webUri,
    required this.color,
  });
}

class _AnimatedContactButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedContactButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedContactButton> createState() => _AnimatedContactButtonState();
}

class _AnimatedContactButtonState extends State<_AnimatedContactButton>
    with SingleTickerProviderStateMixin {
  // Animatsa controlleri
  late AnimationController _animationController;

  // Animatsiyalar
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotationAnimation;

  // Tugma bosilganligi holati
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // Animatsiya controlleri
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Hajm animatsiyasi (kichrayib-kattalashish)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_animationController);

    // Shaffoflik animatsiyasi
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.7)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.7, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 70,
      ),
    ]).animate(_animationController);

    // Rang animatsiyasi
    _colorAnimation = ColorTween(
      begin: widget.color.withValues(alpha: 0.1),
      end: widget.color.withValues(alpha: 0.3),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Aylana animatsiyasi
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
        reverseCurve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Animatsiyani boshlatish
  void _triggerAnimation() {
    if (_isPressed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
              _triggerAnimation();
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
              _triggerAnimation();
            });
            widget.onTap();
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
              _triggerAnimation();
            });
          },
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _colorAnimation.value,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.color
                                  .withOpacity(_isPressed ? 0.25 : 0.15),
                              blurRadius: _isPressed ? 12 : 8,
                              spreadRadius: _isPressed ? 2 : 0,
                              offset: _isPressed
                                  ? const Offset(0, 1)
                                  : const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 28,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
