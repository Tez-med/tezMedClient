import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'dart:math' as math;

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: S.current.expert_guidance,
      description: S.current.expert_guidance_desc,
      imagePath: Assets.images.nurse.path,
    ),
    OnboardingData(
      title: S.current.support,
      description: S.current.support_desc,
      imagePath: Assets.images.support.path,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSkip() {
    context.router.pushAndPopUntil(
      const PhoneInputRoute(),
      predicate: (route) => false,
    );
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _animationController.forward(from: 0);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart,
      );
    } else {
      _onSkip();
    }
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            double scale = 1.0;
            if (_currentPage == index) {
              scale = 1 + math.sin(_animationController.value * math.pi) * 0.3;
            }
            return Transform.scale(
              scale: scale,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(70, 115, 183, 1)
                      .withValues(alpha: _currentPage == index ? 1 : 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData page, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double opacity = 1.0;
        double translateX = 0.0;
        double rotate = 0.0;

        if (_pageController.position.haveDimensions) {
          double pageOffset = _pageController.page! - index;
          opacity = 1 - pageOffset.abs().clamp(0.0, 1.0);
          translateX = MediaQuery.of(context).size.width * -pageOffset;
          rotate = pageOffset * math.pi / 2;
        }

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(translateX, 0)
            ..rotateY(rotate),
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Image.asset(
                          page.imagePath,
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.2,
                    ),
                    child: Text(
                      page.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    page.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSkipButton(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) =>
                    _buildPage(_pages[index], index),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: _onSkip,
        child: Text(
          S.of(context).skip,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildPageIndicator(),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 + math.sin(_animationController.value * math.pi) * 0.1,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1
                          ? S.of(context).next
                          : S.of(context).start,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
