import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    this.consent = false,
    this.controller,
    required this.onPressed,
    required this.isLoading,
    this.buttonColor,
    this.buttonText,
    this.textColor,
  });

  final VoidCallback? onPressed;
  final bool consent;
  final TextEditingController? controller;
  final bool isLoading;
  final Color? buttonColor;
  final String? buttonText;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final currentColor = buttonColor ??
        (consent ? AppColor.primaryColor : AppColor.buttonBackColor);
    final currentTextColor =
        textColor ?? (consent ? Colors.white : Colors.grey);
    final size = MediaQuery.of(context).size;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isLoading ? 50 : size.width,
        height: 50,
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(isLoading ? 25 : 10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(isLoading ? 25 : 10),
          onTap: (consent && !isLoading) ? onPressed : null,
          child: Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 200),
              crossFadeState: isLoading
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    consent ? Colors.white : Colors.black,
                  ),
                  strokeWidth: 2.5,
                ),
              ),
              secondChild: Text(
                buttonText ?? S.of(context).confirm,
                style: AppTextstyle.nunitoBold.copyWith(
                  color: consent ? currentTextColor : Colors.grey,
                  fontSize: 17,
                ),
              ),
              layoutBuilder:
                  (topChild, topChildKey, bottomChild, bottomChildKey) {
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      key: bottomChildKey,
                      child: bottomChild,
                    ),
                    Positioned(
                      key: topChildKey,
                      child: topChild,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
