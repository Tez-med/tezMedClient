import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class SelectTableFeild extends StatelessWidget {
  const SelectTableFeild({
    super.key,
    required bool isValid,
    required this.context,
    required this.title,
    required this.controller,
    required this.onChanged,
  }) : _isValid = isValid;

  final bool _isValid;
  final BuildContext context;
  final String title;
  final TextEditingController controller;
  final void Function(String p1)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextstyle.nunitoMedium.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (!_isValid) {
                return S.of(context).required_field;
              }
              return null;
            },
            keyboardType: TextInputType.number,
            onChanged: (value) => onChanged?.call(value),
            decoration: InputDecoration(
              hintText: '№',
              hintStyle: AppTextstyle.nunitoMedium,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColor.greyTextColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColor.primaryColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColor.buttonBackColor,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
