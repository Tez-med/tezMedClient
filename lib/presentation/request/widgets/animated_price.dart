import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimatedPriceWidget extends StatefulWidget {
  final double initialPrice;
  final double targetPrice;
  final TextStyle? textStyle;
  final Duration animationDuration;

  const AnimatedPriceWidget({
    super.key,
    required this.initialPrice,
    required this.targetPrice,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedPriceWidget> createState() => _AnimatedPriceWidgetState();
}

class _AnimatedPriceWidgetState extends State<AnimatedPriceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final format = NumberFormat("#,###");

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: widget.initialPrice,
      end: widget.targetPrice,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedPriceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetPrice != widget.targetPrice) {
      _animation = Tween<double>(
        begin: oldWidget.targetPrice,
        end: widget.targetPrice,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));

      _animationController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          format.format(_animation.value.toInt()),
          style: widget.textStyle ??
              TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        );
      },
    );
  }
}
