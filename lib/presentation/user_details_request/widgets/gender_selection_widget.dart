import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/user_details_request/widgets/gender_widget.dart';

class GenderSelectionWidget extends StatelessWidget {
  final String? selectedGender;
  final Function(String) onGenderSelected;

  const GenderSelectionWidget({
    required this.selectedGender,
    required this.onGenderSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).gender,
          style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 5),
        GenderWidget(
          gender: S.of(context).male,
          isSelected: selectedGender == "Male", 
          onTap: () => onGenderSelected("Male"), // Changed to lowercase
        ),
        const SizedBox(height: 5),
        GenderWidget(
          gender: S.of(context).female,
          isSelected: selectedGender == "Female", // Changed to lowercase
          onTap: () => onGenderSelected("Female"), // Changed to lowercase
        ),
      ],
    );
  }
}
