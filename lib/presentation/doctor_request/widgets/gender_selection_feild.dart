import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class GenderSelectionField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final Function(String?) onChanged;

  const GenderSelectionField({
    super.key,
    required this.controller,
    this.readOnly = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).gender,
          style: AppTextstyle.nunitoExtraBold.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: AppColor.buttonBackColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            value: (controller.text.isEmpty ||
                    !(["Male", "Female"].contains(controller.text)))
                ? null
                : controller.text,
            items: [
              DropdownMenuItem(
                value: "Male",
                child: Text(S.of(context).male),
              ),
              DropdownMenuItem(
                value: "Female",
                child: Text(S.of(context).female),
              ),
            ],
            onChanged: readOnly ? null : onChanged,
            decoration: InputDecoration(
              hintText: S.of(context).select_gender,
              hintStyle: AppTextstyle.nunitoBold.copyWith(
                fontSize: 17,
                color: AppColor.greyTextColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
