import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';

class ServerConnection extends StatelessWidget {
  final VoidCallback onRetry;

  const ServerConnection({
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Assets.lottie.serverError.lottie(
                animate: true,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              s.connectionError,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildRetryButton(s),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton(S s) {
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
