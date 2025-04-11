import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/profile/widgets/log_out_dialog.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: CupertinoIcons.folder,
            title: S.of(context).order_history,
            onTap: () => context.router.push(const FinishedRequestRoute()),
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: CupertinoIcons.settings_solid,
            title: S.of(context).settings,
            onTap: () => context.router.push(const SettingsRoute()),
          ),
          _buildDivider(),
          if (Platform.isAndroid)
            _buildMenuItem(
              context: context,
              icon: CupertinoIcons.star,
              title: S.of(context).rate_us,
              onTap: () => _rateApp(),
            ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.note_alt_outlined,
            title: S.of(context).diseaseCards,
            onTap: () => context.router.push(DiseasesRoute()),
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: S.of(context).consent4,
            onTap: () => context.router.push(PrivacyPolicy()),
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.share_outlined,
            title: S.of(context).share_app,
            onTap: () => _shareApp(),
          ),
          _buildDivider(),
          _buildLogoutWidget(context),
        ],
      ),
    );
  }

  Future<void> _shareApp() async {
    try {
      const String androidAppUrl =
          'https://play.google.com/store/apps/details?id=uz.client.tezmed';
      const String iosAppUrl = 'https://apps.apple.com/app/idYOUR_IOS_APP_ID';

      final String appUrl = Platform.isAndroid ? androidAppUrl : iosAppUrl;

      await Share.share(appUrl);
    } catch (e) {
      print('Share error: $e');
    }
  }

  Future<void> _rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        final String androidAppUrl =
            'https://play.google.com/store/apps/details?id=uz.client.tezmed';
        final String iosAppUrl = 'https://apps.apple.com/app/idYOUR_IOS_APP_ID';

        final String storeUrl = Platform.isAndroid ? androidAppUrl : iosAppUrl;
        await inAppReview.openStoreListing();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Rate error: $e');
      }
    }
  }
}

Widget _buildMenuItem({
  required IconData icon,
  required String title,
  required BuildContext context,
  required VoidCallback onTap,
}) {
  return Theme(
    data: Theme.of(context).copyWith(
      splashColor: AppColor.buttonBackColor,
      hoverColor: AppColor.buttonBackColor,
    ),
    child: ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColor.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColor.primaryColor,
      ),
      onTap: onTap, // onTap ishlatildi
    ),
  );
}

Widget _buildLogoutWidget(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: ListTile(
      onTap: () => showAnimatedLogoutDialog(context),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.logout_rounded,
          color: Colors.red.shade400,
          size: 20,
        ),
      ),
      title: Text(
        S.of(context).exit,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.red.shade400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColor.primaryColor,
      ),
    ),
  );
}

Widget _buildDivider() {
  return Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey.shade100,
    indent: 56,
  );
}
