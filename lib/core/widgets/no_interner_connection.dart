import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';

import '../utils/app_color.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetConnectionWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.lottie.notConnection.lottie(height: 300),
          const SizedBox(height: 20),
          Text(
            S.of(context).no_internet,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).check_internet,
            style: AppTextstyle.nunitoMedium
                .copyWith(color: AppColor.greyTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
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
        ],
      ),
    );
  }
}
