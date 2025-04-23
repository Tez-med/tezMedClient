import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'dart:developer' as dev;

class ShareClinicSection extends StatelessWidget {
  final Clinic clinic;

  const ShareClinicSection({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.share),
        color: Colors.white,
        iconSize: 20,
        padding: EdgeInsets.zero,
        onPressed: () => _shareClinic(context),
      ),
    );
  }

  // Klinikani ulashish funksiyasi
  void _shareClinic(BuildContext context) async {
    try {
      // Deeplink yaratish
      final String deeplink = _createDeeplink();

      // Ulashish matni
      final String shareText =
          'TezMed ilovasida "${clinic.nameUz}" klinikasi haqida ma\'lumot:\n\n$deeplink';

      // Share dialog ni ko'rsatish
      await Share.share(
        shareText,
        subject: 'TezMed - ${clinic.nameUz}',
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Ulashishda xatolik yuz berdi');
    }
  }

  // Deeplink yaratish
  String _createDeeplink() {
    final String clinicId = clinic.id;
    dev.log(clinicId, name: "ClinicId");
    final String encodedId = base64Url.encode(utf8.encode(clinicId));
    dev.log(encodedId, name: "ClinicId Shifr");

    return 'https://tezmed.uz/referal?s=clinic_details&id=$encodedId';
  }

  // Xatolik haqida xabar ko'rsatish
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Deeplink handler funksiyasi (main.dart yoki router konfiguratsiyasiga qo'shing)
void handleDeeplink(String url) {
  try {
    final Uri uri = Uri.parse(url);

    // Klinika ID sini olish
    if (uri.host == 'clinic' && uri.queryParameters.containsKey('id')) {
      final String clinicId = uri.queryParameters['id']!;
      final String? section = uri.queryParameters['section'];

      // Routing logic
      if (section != null) {
        // Agar section ko'rsatilgan bo'lsa, u bilan navigatsiya
        navigateToClinicSection(clinicId, section);
      } else {
        // Asosiy klinika sahifasiga o'tish
        navigateToClinic(clinicId);
      }
    }
  } catch (e) {
    debugPrint('Deeplink ni qayta ishlashda xatolik: $e');
  }
}

// NavigatorState orqali routing (asosiy navigatsiya kodingizga qo'shing)
void navigateToClinic(String clinicId) {
  // Clinic sahifasiga o'tish
  // Navigator.of(context).pushNamed('/clinic/$clinicId');
}

void navigateToClinicSection(String clinicId, String section) {
  // Clinic sahifasiga o'tish va keyin section ga scroll qilish
  // Bu routing logikasi sizning app strukturangizga qarab o'zgartirilishi kerak
  // Navigator.of(context).pushNamed('/clinic/$clinicId', arguments: {'scrollToSection': section});
}
