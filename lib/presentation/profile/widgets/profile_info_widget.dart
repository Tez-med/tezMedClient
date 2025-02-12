import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';
import 'package:tez_med_client/presentation/profile/widgets/profile_avater_widget.dart';
import 'package:tez_med_client/presentation/profile/widgets/profile_data_widget.dart';

class ProfileInfoWidget extends StatelessWidget {
  final ClientModel clientModel;
  const ProfileInfoWidget({
    super.key,
    required this.clientModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.router.push(ProfileUpdateRoute(clientModel: clientModel)),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ProfileAvatarWidget(clientModel: clientModel),
            const SizedBox(width: 16),
            Expanded(
              child: ProfileDataWidget(clientModel: clientModel),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColor.primaryColor,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
