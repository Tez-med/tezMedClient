import 'package:flutter/material.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCallHandler {
  /// Klinika raqamlariga ko'ra tegishli harakatni bajaradi:
  /// - Raqam yo'q bo'lsa - xabar ko'rsatiladi
  /// - Bitta raqam bo'lsa - to'g'ridan-to'g'ri qo'ng'iroq qilinadi
  /// - Ko'p raqam bo'lsa - tanlash uchun modal ko'rsatiladi
  static void handlePhoneCall(
    BuildContext context,
    List<String> phoneNumbers,
  ) {
    if (phoneNumbers.isEmpty) {
    } else if (phoneNumbers.length == 1) {
      _makeCall(phoneNumbers[0]);
    } else {
      _showPhoneSelectionDialog(context, phoneNumbers);
    }
  }

  /// Bitta raqamga qo'ng'iroq qilish
  static void _makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      launchUrl(phoneUri);
    }
  }

  /// Raqam mavjud emasligi haqida xabar

  /// Ko'p raqamlar uchun tanlash dialogini ko'rsatish
  static void _showPhoneSelectionDialog(
    BuildContext context,
    List<String> phoneNumbers,
  ) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal yuqorisidagi chiziq
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sarlavha
                  Row(
                    children: [
                      Icon(Icons.phone, color: primaryColor, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        S.of(context).select_phone,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  // Raqamlar ro'yxati
                  ...phoneNumbers.map((phone) => _buildPhoneNumberTile(
                        context,
                        phone,
                        primaryColor,
                      )),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Telefon raqamining chiroyli dizayni
  static Widget _buildPhoneNumberTile(
    BuildContext context,
    String phone,
    Color primaryColor,
  ) {
    // Raqamni formatlash (agar raqam formati o'zgartirilishi kerak bo'lsa)
    String displayPhone = _formatPhoneNumber(phone);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _makeCall(phone);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Icon(Icons.phone_in_talk, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayPhone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                     Text(
                      S.of(context).tap_to_call,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.call_outlined,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Telefon raqamini chiroyli formatda ko'rsatish
  /// Masalan: +998 90 123 4567 -> +998 (90) 123-45-67
  static String _formatPhoneNumber(String phone) {
    // Agar raqam formati boshqacha bo'lsa, uni formatlash
    // Bu oddiy misol, kerakli formatga moslashtirishingiz mumkin
    phone = phone.replaceAll(' ', '').replaceAll('-', '');

    if (phone.startsWith('+998') && phone.length >= 12) {
      return '+998 (${phone.substring(4, 6)}) ${phone.substring(6, 9)}-${phone.substring(9, 11)}-${phone.substring(11)}';
    }

    return phone; // Agar raqam boshqa formatda bo'lsa, o'zgarishsiz qaytaramiz
  }
}
