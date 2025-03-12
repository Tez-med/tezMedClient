import 'package:flutter/material.dart';

class DialogButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const DialogButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isFullWidth = false,
  });

  @override
  State<DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<DialogButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.isFullWidth ? double.infinity : null,
          child: ElevatedButton.icon(
            onPressed: () {
              _controller.forward().then((_) {
                _controller.reverse().then((_) {
                  widget.onPressed();
                });
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              shadowColor: widget.color.withValues(alpha: 0.5),
            ),
            label: Text(
              widget.text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
