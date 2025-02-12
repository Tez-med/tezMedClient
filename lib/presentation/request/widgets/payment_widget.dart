import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';

class PaymentWidget extends StatelessWidget {
  const PaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).payment_type,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
             Text(
              S.of(context).payment_other,
              style: AppTextstyle.nunitoRegular,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Assets.icons.payment.image(
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  S.of(context).cash,
                  style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
