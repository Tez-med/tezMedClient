import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import '../../../generated/l10n.dart';

class NoServicesWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoServicesWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon o'rniga
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColor.buttonBackColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.map, // Cupertino ikonkasi
                size: 60,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            // Ko'p tillilik uchun S.of(context) orqali olamiz
            Text(
              S.of(context).no_services_available,
              style: AppTextstyle.nunitoBold.copyWith(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                S.of(context).no_services_description,
                style: AppTextstyle.nunitoMedium.copyWith(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
