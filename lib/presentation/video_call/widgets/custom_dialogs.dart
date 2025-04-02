import 'package:flutter/material.dart';
import 'package:tez_med_client/presentation/video_call/widgets/dialog_button.dart';
import 'package:tez_med_client/presentation/video_call/widgets/dialog_content.dart';

import '../../../core/utils/app_color.dart';
import '../../../generated/l10n.dart'; // Lokalizatsiya uchun import

class DialogHelper {
  static Future<bool?> showExitConfirmationDialog(BuildContext context) async {
    if (!context.mounted) return null; // Navigator mavjudligini tekshirish
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: S.of(context).exitDialog,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity:
                Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 32),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: DialogContent(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  progress: animation,
                  color: Colors.white,
                  size: 48,
                ),
                title: S.of(context).exitTitle,
                description: S.of(context).exitDescription,
                buttons: [
                  DialogButton(
                    text: S.of(context).Continue,
                    icon: Icons.videocam,
                    color: Colors.grey[700]!,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  DialogButton(
                    text: S.of(context).endText,
                    icon: Icons.call_end,
                    color: Colors.red,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showInfoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: S.of(context).infoDialog, // Lokalizatsiya qilingan
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutBack,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity:
                Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 32),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: DialogContent(
                icon: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 2 * 3.14,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.primaryColor.withValues(alpha: 0.2),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: AppColor.primaryColor,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
                title: S.of(context).infoTitle,
                description: S.of(context).infoDescription,
                extraContent: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoItem(
                      icon: Icons.fullscreen,
                      text: S.of(context).fullscreenText,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoItem(
                      icon: Icons.call_end,
                      text: S.of(context).endCallText,
                    ),
                  ],
                ),
                singleButton: DialogButton(
                  text: S.of(context).understoodText,
                  icon: Icons.check_circle,
                  color: AppColor.primaryColor,
                  onPressed: () => Navigator.of(context).pop(),
                  isFullWidth: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildInfoItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: AppColor.primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
