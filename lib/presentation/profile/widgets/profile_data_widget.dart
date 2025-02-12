import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';

import '../../../core/utils/app_color.dart';

class ProfileDataWidget extends StatelessWidget {
  final ClientModel clientModel;

  const ProfileDataWidget({super.key, required this.clientModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          clientModel.fullName,
          style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          clientModel.phoneNumber,
          style: AppTextstyle.nunitoBold
              .copyWith(fontSize: 15, color: AppColor.greyTextColor),
        ),
      ],
    );
  }
}
