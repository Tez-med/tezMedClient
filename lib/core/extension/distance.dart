import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

extension DistanceExtension on BuildContext {
  /// Joriy joylashuvdan (current location) berilgan nuqtagacha bo‘lgan masofani km da qaytaradi.
  Future<double> distanceInKm({
    required double destinationLat,
    required double destinationLng,
  }) async {
    // Permissionlarni tekshiramiz
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Lokatsiyaga ruxsat berilmadi.');
      }
    }

    // Hozirgi joylashuvni olamiz
    final currentPosition = await Geolocator.getCurrentPosition();

    // Masofani hisoblaymiz
    final distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      destinationLat,
      destinationLng,
    );

    return distanceInMeters / 1000; 
  }
}
