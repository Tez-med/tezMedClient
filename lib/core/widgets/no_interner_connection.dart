import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/core/utils/app_color.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetConnectionWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.lottie.notConnection.lottie(
              height: 240,
              animate: true,
            ),
            const SizedBox(height: 24),
            Text(
              s.no_internet,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              s.check_internet,
              style: AppTextstyle.nunitoMedium.copyWith(
                color: AppColor.greyTextColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildRetryButton(context, s),
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context, S s) {
    return ElevatedButton(
      onPressed: onRetry,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
      child: Text(
        s.send_again,
        style: AppTextstyle.nunitoBold.copyWith(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
