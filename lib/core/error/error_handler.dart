import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      // Guruh 1: Sertifikat va ulanish bilan bog'liq xatolar
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
        return const NetworkFailure(
          code: 500,
        );

      // Guruh 2: Timeout va boshqa xatolar
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.unknown:
        return const DioFailure(
          DioExceptionType.sendTimeout,
          code: 400,
        );

      // Guruh 2: Bekor qilish xatolari
      case DioExceptionType.cancel:
        return const DioFailure(
          DioExceptionType.cancel,
          code: 401,
        );

      }
  }

  static String getErrorMessage(BuildContext context, int code) {
    switch (code) {
      case 400:
        return "Internet aloqasi yaxshi emas";
      case 500:
        return "Server bilan aloqa uzildi";
      default:
        return "Kutilmagan xatolik yuz berdi";
    }
  }

  static void showError(BuildContext context, int code) {
    final message = getErrorMessage(context, code);
    AnimatedCustomSnackbar.show(
        context: context, message: message, type: SnackbarType.error);
  }
}
