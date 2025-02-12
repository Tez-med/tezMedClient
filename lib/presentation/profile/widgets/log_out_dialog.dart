import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/generated/l10n.dart';

// Optional: Animated version of the logout dialog
void showAnimatedLogoutDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation1, animation2) => Container(),
    transitionBuilder: (context, animation1, animation2, child) {
      return Transform.scale(
        scale: Curves.easeOutBack.transform(animation1.value),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon with animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: Colors.red.shade400,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Fade in animation for text
                FadeTransition(
                  opacity: animation1,
                  child: Column(
                    children: [
                      Text(
                        S.of(context).confirm_exit,
                        style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        S.of(context).really_quit,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Slide up animation for buttons
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation1,
                    curve: Curves.easeOutBack,
                  )),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => context.router.maybePop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            S.of(context).cancel,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            LocalStorageService().removeKey(StorageKeys.userId);
                            LocalStorageService()
                                .removeKey(StorageKeys.isRegister);
                            context.router
                                .replaceAll([const PhoneInputRoute()]);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            S.of(context).exit,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
