import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Xaritani yuklashda xatolik yuz berdi',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Qayta yuklash'),
          ),
        ],
      ),
    );
  }
}