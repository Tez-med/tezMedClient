import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String label;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final double size;

  const RoundButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.label,
    required this.animationController,
    required this.scaleAnimation,
    this.size = 56,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          // onTapDown: (_) => widget.animationController.forward(),
          // onTapUp: (_) => widget.animationController.reverse(),
          onTap: () => widget.onPressed(),
          // onTapCancel: () => widget.animationController.reverse(),
          child: ScaleTransition(
            scale: widget.scaleAnimation,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.onPressed,
                  splashColor: Colors.white24,
                  highlightColor: Colors.white10,
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: widget.size * 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
