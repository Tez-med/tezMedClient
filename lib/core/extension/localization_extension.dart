import 'package:flutter/cupertino.dart';

extension LocalizationExtension on BuildContext {
  String toLocalized(
      {required String uz, required String ru, required String en}) {
    final lang = Localizations.localeOf(this).languageCode;
    switch (lang) {
      case 'uz':
        return uz;
      case 'ru':
        return ru;
      default:
        return en;
    }
  }
}
