import 'package:flutter/material.dart';
import 'package:tez_med_client/generated/l10n.dart';

import '../../../core/utils/app_color.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<int> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _sizeAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _dotsAnimation = IntTween(begin: 1, end: 4).animate(
      CurvedAnimation(
        parent: _controller,
        // Faster animation with more frequent changes
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getDots(int count) {
    return '.' * count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.secondary,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SizedBox(
                  width: 60,
                  height: 60,
                  child: Transform.scale(
                    scale: _sizeAnimation.value,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.primaryColor.withValues(
                              alpha: 1.0 - (_sizeAnimation.value - 0.5)),
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Improved dots animation
            AnimatedBuilder(
              animation: _dotsAnimation,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).loading_video,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 40, 
                      child: Text(
                        _getDots(_dotsAnimation.value),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
