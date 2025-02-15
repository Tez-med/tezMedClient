import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';

import '../../../core/utils/app_color.dart';
import '../../../core/utils/app_textstyle.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController phoneController;
  final bool readOnly;
  final FocusNode? focusNode;
  final bool isFlag;
  final String? Function(String?)? validator;

  const PhoneInputField({
    super.key,
    this.readOnly = false,
    required this.phoneController,
    this.validator,
    this.focusNode,
    this.isFlag = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).input_phone_number;
            } else if (value.length != 12) {
              return S.of(context).check_phone;
            }
            return null;
          },
      focusNode: focusNode,
      controller: phoneController,
      style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskedInputFormatter('## ### ## ##',
            allowedCharMatcher: RegExp(r'[0-9]')),
      ],
      readOnly: readOnly,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.buttonBackColor,
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isFlag
                ? Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Image.asset(
                      Assets.icons.bayroq.path,
                      width: 24,
                      height: 24,
                    ),
                  )
                : SizedBox(),
            const SizedBox(width: 8),
            Text(
              '+998 ',
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
            ),
          ],
        ),
        hintStyle: AppTextstyle.nunitoMedium
            .copyWith(color: AppColor.greyTextColor, fontSize: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
        // contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}
