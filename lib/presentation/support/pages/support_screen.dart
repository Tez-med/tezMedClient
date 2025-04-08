import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          S.of(context).helpSupport,
          style: AppTextstyle.nunitoBold.copyWith(fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).contactPlatforms,
                style: AppTextstyle.nunitoBold.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  _buildAnimatedContactItem(
                    icon: FontAwesomeIcons.youtube,
                    title: S.of(context).youtube,
                    subtitle: S.of(context).videoGuides,
                    color: const Color(0xFFFF0000),
                    onTap: () => _launchUrl('https://youtube.com/@TezMed'),
                    delay: 0,
                  ),
                  _buildAnimatedContactItem(
                    icon: FontAwesomeIcons.instagram,
                    title: S.of(context).instagram,
                    subtitle: S.of(context).latestUpdates,
                    color: const Color(0xFFE1306C),
                    onTap: () => _launchUrl('https://instagram.com/tezmed_uz'),
                    delay: 100,
                  ),
                  _buildAnimatedContactItem(
                    icon: FontAwesomeIcons.telegram,
                    title: S.of(context).telegram,
                    subtitle: S.of(context).chatSupport,
                    color: const Color(0xFF0088CC),
                    onTap: () => _launchUrl('https://t.me/tezmed_uz'),
                    delay: 200,
                  ),
                  _buildAnimatedContactItem(
                    icon: Icons.phone_in_talk_rounded,
                    title: S.of(context).callCenter,
                    subtitle: '+998 55 514 00 03',
                    color: const Color(0xFF4CAF50),
                    onTap: () => _launchUrl('tel:+998555140003'),
                    delay: 300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextstyle.nunitoBold.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: AppTextstyle.nunitoMedium.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColor.greyColor500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: color,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      // Telegram URL'ni aniqlaymiz va maxsus ishlaymiz
      if (url.contains('t.me') || url.contains('telegram.me')) {
        // Telegram app URL formatiga o'tkazish
        final String telegramAppUrl = url.replaceFirst('https://', 'tg://');
        final Uri telegramUri = Uri.parse(telegramAppUrl);

        // Telegram ilovasi o'rnatilganligini tekshirish
        if (await canLaunchUrl(telegramUri)) {
          // Agar o'rnatilgan bo'lsa, to'g'ridan-to'g'ri ilova ochiladi
          await launchUrl(telegramUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      // Telegram bo'lmagan boshqa URL'lar uchun yoki Telegram o'rnatilmagan holatlar
      final Uri uri = Uri.parse(url);

      // URL turiga qarab mode tanlash
      LaunchMode mode;

      if (url.startsWith('tel:') ||
          url.startsWith('sms:') ||
          url.startsWith('mailto:') ||
          url.startsWith('https://t.me/')) {
        // Telegram web versiyasi uchun ham
        // Tashqi ilova bilan ochish
        mode = LaunchMode.externalApplication;
      } else {
        // Web URLlar uchun in-app view
        mode = LaunchMode.inAppWebView;
      }

      // URL ochishga urinish
      final bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(uri, mode: mode);
      } else {
        // Agar ochilmasa, mode ni o'zgartirib ko'rish
        if (mode == LaunchMode.inAppWebView) {
          // In-app ochilmasa, tashqi ilova bilan ochishga urinish
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Platformaga bog'liq bo'lmagan ochish usuli
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      }
    } catch (e) {
      debugPrint('URL ochishda xatolik: $e');

      try {
        // Xatolik bo'lsa, oxirgi imkoniyat sifatida platformaga bog'liq
        // bo'lmagan ochish usulini sinab ko'rish
        final Uri uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e2) {
        // Hech qanday usul ishlamasa, debug log ga yozish
        debugPrint('URL ochilmadi: $url, Xatolik: $e2');
      }
    }
  }
}
