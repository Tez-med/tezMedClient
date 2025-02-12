import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateManager {
  /// Checks for an available update and triggers it if available.
  Future<void> checkForUpdate() async {
    try {
      // Fetch the update availability information.
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      // If update is available, initiate the update process.
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        _performUpdate();
      }
    } catch (e) {
      // Handle the error and log it.
      debugPrint('Yangilanishni tekshirishda xato: $e');
    }
  }

  /// Initiates the update process.
  Future<void> _performUpdate() async {
    try {
      // Perform an immediate update if required.
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      // Handle any errors during the update process.
      debugPrint('Yangilanishni o\'tkazishda xato: $e');
    }
  }
}
