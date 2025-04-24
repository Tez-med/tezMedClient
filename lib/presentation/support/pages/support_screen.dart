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

  // Ilova linklar va ularning deep link versiyalari
  static final Map<String, String> _appDeepLinks = {
    'https://youtube.com/@TezMed': 'youtube://channel/TezMed',
    'https://instagram.com/tezmed_uz': 'instagram://user?username=tezmed_uz',
    'https://t.me/tezmed_uz': 'tg://resolve?domain=tezmed_uz',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).helpSupport,
        ),
      ),
      body: SingleChildScrollView(
        physics:
            const ClampingScrollPhysics(), // iOS bounce effektini yo'q qiladi
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
              _buildContactsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactsList(BuildContext context) {
    final contactItems = [
      ContactItem(
        icon: FontAwesomeIcons.youtube,
        title: S.of(context).youtube,
        subtitle: S.of(context).videoGuides,
        color: const Color(0xFFFF0000),
        url: 'https://youtube.com/@TezMed',
      ),
      ContactItem(
        icon: FontAwesomeIcons.instagram,
        title: S.of(context).instagram,
        subtitle: S.of(context).latestUpdates,
        color: const Color(0xFFE1306C),
        url: 'https://instagram.com/tezmed_uz',
      ),
      ContactItem(
        icon: FontAwesomeIcons.telegram,
        title: S.of(context).telegram,
        subtitle: S.of(context).chatSupport,
        color: const Color(0xFF0088CC),
        url: 'https://t.me/tezmed_uz',
      ),
      ContactItem(
        icon: Icons.phone_in_talk_rounded,
        title: S.of(context).callCenter,
        subtitle: '+998 55 514 00 03',
        color: const Color(0xFF4CAF50),
        url: 'tel:+998555140003',
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contactItems.length,
      itemBuilder: (context, index) {
        final item = contactItems[index];
        return _buildAnimatedContactItem(
          icon: item.icon,
          title: item.title,
          subtitle: item.subtitle,
          color: item.color,
          onTap: () => _launchUrl(item.url),
          delay: index * 100,
        );
      },
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          color: Colors.transparent,
          margin: EdgeInsets.zero,
          elevation: 0,
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
      // 1. Avval deep link versiyasini tekshirish
      final String? deepLink = _getDeepLink(url);

      if (deepLink != null) {
        final deepLinkUri = Uri.parse(deepLink);
        // Ilova o'rnatilgan bo'lsa, to'g'ridan-to'g'ri ochish
        if (await canLaunchUrl(deepLinkUri)) {
          await launchUrl(deepLinkUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      // 2. Agar deep link bilan ochib bo'lmasa, oddiy URL bilan ochish
      final uri = Uri.parse(url);

      // Telefon, SMS, email va tashqi ilovalar uchun LaunchMode.externalApplication
      LaunchMode mode;
      if (_isExternalAppUrl(url)) {
        mode = LaunchMode.externalApplication;
      } else {
        // Web saytlar uchun LaunchMode.inAppWebView
        mode = LaunchMode.inAppWebView;
      }

      await launchUrl(uri, mode: mode);
    } catch (e) {
      debugPrint('URL ochishda xatolik: $e');

      // Fallback - har qanday holatda platformaga mos ravishda ochish
      try {
        final uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e2) {
        debugPrint('URL ochilmadi: $url, Xatolik: $e2');
      }
    }
  }

  // URL uchun tegishli deep link ni qaytaradi
  String? _getDeepLink(String url) {
    // Social media ilovalar uchun deep link
    if (_appDeepLinks.containsKey(url)) {
      return _appDeepLinks[url];
    }

    // Telefon raqam uchun
    if (url.startsWith('tel:')) {
      return url;
    }

    return null;
  }

  // URL tashqi ilovada ochilishi kerak yoki yo'qligini aniqlaydi
  bool _isExternalAppUrl(String url) {
    return url.startsWith('tel:') ||
        url.startsWith('sms:') ||
        url.startsWith('mailto:') ||
        url.contains('youtube.com') ||
        url.contains('instagram.com') ||
        url.contains('t.me') ||
        url.contains('telegram.me');
  }
}

// ContactItem klassi - kod tozaligi uchun
class ContactItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String url;

  ContactItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.url,
  });
}
