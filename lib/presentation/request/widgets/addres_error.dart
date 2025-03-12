import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/request/bloc/my_address/my_address_bloc.dart';

class AddressError2 extends StatelessWidget {
  const AddressError2({
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
              Icons.cloud_off,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              S.of(context).region_error,
              style: AppTextstyle.nunitoBold.copyWith(
                fontSize: 20,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).region_error_desc,
              style: AppTextstyle.nunitoMedium.copyWith(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () =>
                  context.read<MyAddressBloc>().add(FetchMyAddress()),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.primaryColor,
                side: BorderSide(color: AppColor.primaryColor),
              ),
              child: Text(
                S.of(context).retry,
                style: AppTextstyle.nunitoMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddreesError extends StatelessWidget {
  const AddreesError({
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
              size: 50,
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
              style: AppTextstyle.nunitoMedium.copyWith(
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
