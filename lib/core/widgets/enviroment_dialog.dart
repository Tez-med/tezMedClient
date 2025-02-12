import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/config/environment.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';

class EnvironmentDialog extends StatelessWidget {
  EnvironmentDialog({super.key});
  final TextEditingController _pin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      title: const Text(
        'PIN-kodni kiriting',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3142),
        ),
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextField(
          controller: _pin,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            hintText: 'code',
            border: InputBorder.none,
            counterText: '',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
          onSubmitted: (pin) => _verifyPin(context, pin),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Bekor qilish'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _verifyPin(context, _pin.text),
                child: const Text('Tasdiqlash'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _verifyPin(BuildContext context, String pin) {
    final now = DateTime.now();
    final currentPin =
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    if (pin == currentPin) {
      Navigator.pop(context);
      _showEnvironmentSelector(context);
    }
  }

  void _showEnvironmentSelector(BuildContext context) {
    final isDev = EnvironmentConfig.instance.isDev;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Mavjud muhit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              isDev ? 'DEV (Tajriba muhiti)' : 'PROD (Ishchi muhiti)',
              style: TextStyle(
                fontSize: 16,
                color: isDev ? Colors.blue : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: !isDev ? Colors.grey : AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (!isDev) {
                EnvironmentConfig.switchEnvironment(Environment.dev);
                LocalStorageService().removeKey(StorageKeys.userId);
                LocalStorageService().removeKey(StorageKeys.isRegister);
                context.router.replaceAll([const PhoneInputRoute()]);
              }
              context.router.maybePop();
            },
            child: const Text('Tajriba (DEV)'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: !isDev ? AppColor.primaryColor : Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (isDev) {
                EnvironmentConfig.switchEnvironment(Environment.prod);
                LocalStorageService().removeKey(StorageKeys.userId);
                LocalStorageService().removeKey(StorageKeys.isRegister);
                context.router.replaceAll([const PhoneInputRoute()]);
              }
              context.router.maybePop();
            },
            child: const Text('Ishchi (PROD)'),
          ),
        ],
      ),
    );
  }
}
