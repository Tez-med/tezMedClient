import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/profile_update/model/profile_update_model.dart';
import 'package:tez_med_client/domain/notification/repositories/notification_repository.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/injection.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_update/profile_update_bloc.dart';

import '../../../generated/l10n.dart';

class RegisterSuccessDialog extends StatefulWidget {
  const RegisterSuccessDialog({
    super.key,
  });

  @override
  State<RegisterSuccessDialog> createState() => _RegisterSuccessDialogState();
}

class _RegisterSuccessDialogState extends State<RegisterSuccessDialog> {
  late final ProfileUpdateBloc _profileUpdateBloc;

  @override
  void initState() {
    super.initState();
    // Get reference to the bloc when the widget initializes
    _profileUpdateBloc = context.read<ProfileUpdateBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              Assets.lottie.success.path,
              width: 200,
              height: 200,
              repeat: false,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    const ['**'],
                    value: AppColor.primaryColor,
                  ),
                ],
              ),
              onLoaded: (composition) {
                Future.delayed(composition.duration, () async {
                  // Store necessary data before popping
                  final token =
                      await getIt<NotificationRepository>().getFcmToken();
                  final profileUpdateModel = ProfileUpdateModel(
                    birthday: "",
                    fullName: "",
                    gender: "",
                    latitude: "",
                    longitude: "",
                    phoneNumber: "",
                    photo: "",
                    fcmToken: token!,
                    updatedAt: DateTime.now().toString(),
                  );

                  // Update profile before navigation changes
                  _profileUpdateBloc.add(ProfileUpdate(profileUpdateModel));

                  // Check if context is still valid before navigation
                  if (mounted) {
                    context.router.replaceAll([const MainRoute()]);
                  }
                });
              },
            ),
            const SizedBox(height: 10),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 700),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    S.of(context).successfully_register,
                    style: AppTextstyle.nunitoMedium.copyWith(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
