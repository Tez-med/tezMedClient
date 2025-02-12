import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';

import '../../gen/assets.gen.dart';
import '../../generated/l10n.dart';

class ServerConnection extends StatelessWidget {
  final VoidCallback onRetry;

  const ServerConnection({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Assets.lottie.serverError.lottie()),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).connectionError,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                S.of(context).send_again,
                style: AppTextstyle.nunitoBold.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
