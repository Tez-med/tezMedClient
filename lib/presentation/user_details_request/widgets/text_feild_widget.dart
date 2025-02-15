import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';

class TextFeildWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  const TextFeildWidget({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.validator,
    this.readOnly = false,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextstyle.nunitoExtraBold.copyWith(fontSize: 17),
        ),
        TextFormField(
          readOnly: readOnly,
          style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
          textCapitalization: TextCapitalization.words,
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextstyle.nunitoBold
                .copyWith(color: AppColor.greyTextColor, fontSize: 17),
            filled: true,
            fillColor: AppColor.buttonBackColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: AppColor.primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
