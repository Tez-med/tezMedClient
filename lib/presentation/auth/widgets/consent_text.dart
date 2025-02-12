import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class ConsentText extends StatelessWidget {
  const ConsentText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: S.of(context).consent1,
            style: AppTextstyle.nunitoMedium.copyWith(color: Colors.black),
          ),
          TextSpan(
            text: S.of(context).consent2,
            style: AppTextstyle.nunitoMedium
                .copyWith(color: AppColor.primaryColor),
          ),
          TextSpan(
            text: S.of(context).consent3,
            style: AppTextstyle.nunitoMedium.copyWith(color: Colors.black),
          ),
          TextSpan(
            text: S.of(context).consent4,
            style: AppTextstyle.nunitoMedium
                .copyWith(color: AppColor.primaryColor),
          ),
          TextSpan(
            text: S.of(context).consent5,
            style: AppTextstyle.nunitoMedium.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
