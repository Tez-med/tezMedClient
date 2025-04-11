import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';

import '../../core/routes/app_routes.gr.dart';
// import '../../core/utils/app_color.dart';
// import '../../core/utils/app_textstyle.dart';
import '../../gen/assets.gen.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _heartbeatController;
  late final Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNextScreen();
  }

  void _setupAnimations() {
    // Yurak urishi animatsiyasi
    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _heartbeatAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 10),
    ]).animate(CurvedAnimation(
      parent: _heartbeatController,
      curve: Curves.easeInOut,
    ));

    _heartbeatController.repeat();
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = LocalStorageService();
    final isRegister = prefs.getBool(StorageKeys.isRegister);

    final isFirstEntry = prefs.getBool(StorageKeys.firstEntry);

    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;
    if (!isFirstEntry) {
      await prefs.setBool(StorageKeys.firstEntry, true);
      if (mounted) {
        await context.router.replaceAll([LanguageSelectRoute()]);
      }
    } else {
      if (mounted) {
        if (isRegister) {
          await context.router.replaceAll([const MainRoute()]);
        } else {
          await context.router.replaceAll([const PhoneInputRoute()]);
        }
      }
    }
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _heartbeatController,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Transform.scale(
                    //   scale: _heartbeatAnimation.value,
                    //   child: Assets.images.logoPng.image(
                    //     width: 200,
                    //     height: 200,
                    //     // fit: BoxFit.cover,
                    //   ),
                    // ),
                    Transform.scale(
                      scale: _heartbeatAnimation.value,
                      child: Assets.images.logoPng.image(
                        width: 100,
                        height: 100,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    // RichText(
                    //   text: TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text: "Tez",
                    //         style: AppTextstyle.nunitoExtraBold
                    //             .copyWith(fontSize: 35, color: Colors.red),
                    //       ),
                    //       TextSpan(
                    //         text: "Med",
                    //         style: AppTextstyle.nunitoExtraBold.copyWith(
                    //             fontSize: 35, color: AppColor.primaryColor),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // Text('Mijozlar uchun',
                    //     style: AppTextstyle.nunitoMedium.copyWith(
                    //       fontSize: 20,
                    //       color: AppColor.primaryColor,
                    //     )),
                    // const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.black.withValues(alpha: 0.5),
          //   ),
          // ),
        ],
      ),
    );
  }
}
