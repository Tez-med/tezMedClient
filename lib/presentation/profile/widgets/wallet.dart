import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';

class WalletAndRating extends StatelessWidget {
  final ClientModel? clientModel;
  const WalletAndRating({super.key, this.clientModel});

  @override
  Widget build(BuildContext context) {
    if (clientModel == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () => context.router
            .push(WalletRoute(amount: clientModel!.amount.toString())),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: InfoCard(
            icon: Assets.icons.wallet.svg(),
            title: S.of(context).wallet,
            value: '${clientModel!.amount} ${S.of(context).sum}',
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  String formatAmount(String amount) {
    return amount.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[0]} ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.buttonBackColor.withValues(alpha: 0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: icon,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextstyle.nunitoBold.copyWith(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatAmount(value),
                  style: AppTextstyle.nunitoBold.copyWith(
                    fontSize: 18,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColor.primaryColor,
          )
        ],
      ),
    );
  }
}
