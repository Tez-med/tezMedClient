import 'package:tez_med_client/core/routes/app_routes.dart';
import 'package:tez_med_client/generated/l10n.dart';

import '../models/validation_result.dart';

class FormValidators {
  static ValidationResult validateFullName(String? value) {
    final context = AppRouter.instance.navigatorKey.currentContext;
    if (context != null) {
      if (value == null || value.trim().isEmpty) {
        return ValidationResult.failure(S.of(context).please_fullname);
      }

      final nameParts = value.trim().split(' ');
      if (nameParts.length < 2) {
        return ValidationResult.failure(S.of(context).please_fullname);
      }

      if (!nameParts.every((part) =>
          part.isNotEmpty &&
          RegExp(r'^[a-zA-ZА-Яа-яЎўҚқҒғҲҳ]+$').hasMatch(part))) {
        return ValidationResult.failure(
            S.of(context).name_only_letter);
      }
    }

    return ValidationResult.success();
  }

  static ValidationResult validatePhoneNumber(String value) {
    if (value.isEmpty) return ValidationResult.success();
    final context = AppRouter.instance.navigatorKey.currentContext;

    if (context != null) {
      final cleanPhone = value.replaceAll(' ', '');
      if (!RegExp(r'^\d{9}$').hasMatch(cleanPhone)) {
        return ValidationResult.failure(S.of(context).check_phone);
      }
    }

    return ValidationResult.success();
  }

  static ValidationResult validateDate(DateTime? date) {
    final context = AppRouter.instance.navigatorKey.currentContext;

    if (context != null) {
      if (date == null) {
        return ValidationResult.failure(S.of(context).please_date);
      }
    }

    return ValidationResult.success();
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return '';
    final cleaned = phoneNumber.replaceAll(' ', '');
    return '+998$cleaned';
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
