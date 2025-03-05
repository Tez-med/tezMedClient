import 'package:flutter/material.dart';
import 'package:tez_med_client/generated/l10n.dart';

import '../../../core/utils/app_color.dart';
import '../../../core/utils/app_textstyle.dart';

class MyAdressEmpty extends StatelessWidget {
  const MyAdressEmpty({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_rounded,
              color: AppColor.greyColor500,
            ),
            const SizedBox(height: 24),
            Text(
              S.of(context).address_not_found,
              style: AppTextstyle.nunitoBold.copyWith(
                fontSize: 20,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).address_not_found_desc,
              textAlign: TextAlign.center,
              style: AppTextstyle.nunitoRegular.copyWith(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
