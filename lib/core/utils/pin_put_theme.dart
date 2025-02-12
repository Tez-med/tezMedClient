import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';

class PinPutTheme {
  static PinTheme defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: AppTextstyle.nunitoBold
        .copyWith(fontSize: 22, color: AppColor.primaryColor),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColor.greyTextColor.withValues(alpha: 0.5)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: const Offset(0, 3),
          blurRadius: 6,
        )
      ],
    ),
  );

  static final focusedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration!.copyWith(
      border: Border.all(color: AppColor.primaryColor, width: 2),
    ),
  );

  static final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration!.copyWith(
      color: AppColor.primaryColor.withValues(alpha: 0.1),
      border: Border.all(color: AppColor.primaryColor),
    ),
  );
}
