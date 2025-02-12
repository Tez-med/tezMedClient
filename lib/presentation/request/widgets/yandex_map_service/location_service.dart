import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:developer' as developer;

class LocationService {
  final LocalStorageService _localStorage = LocalStorageService();

  Future<Point?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      _saveLocationData(position.latitude, position.longitude);

      final point =
          Point(latitude: position.latitude, longitude: position.longitude);
      final address =
          await getAddressFromCoordinates(point) ?? "Noma'lum joylashuv";
      _localStorage.setString(StorageKeys.locationName, address);

      return point;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Future<void> _saveLocationData(double latitude, double longitude) async {
    _localStorage.setString(StorageKeys.latitude, latitude.toString());
    _localStorage.setString(StorageKeys.longitude, longitude.toString());
  }

  Future<String?> getAddressFromCoordinates(Point point) async {
    try {
      final resultWithSession = await YandexSearch.searchByPoint(
        point: point,
        searchOptions: const SearchOptions(
          searchType: SearchType.geo,
          geometry: false,
        ),
      );

      final data = await resultWithSession.$2;
      if (data.items?.isNotEmpty ?? false) {
        final address =
            data.items![0].toponymMetadata?.address.formattedAddress;
        if (address != null) {
          developer.log(address);
          return _extractRelevantAddress(address);
        }
      }
      return await _getFallbackAddress(point);
    } catch (e) {
      debugPrint('Error getting address: $e');
      return await _getFallbackAddress(point);
    }
  }

  String _extractRelevantAddress(String fullAddress) {
    List<String> parts = fullAddress.split(",");
    if (parts.length > 4) {
      return "${parts[4].trim()}, ${parts[3].trim()}";
    }
    return fullAddress;
  }

  Future<String> _getFallbackAddress(Point point) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        return place.subLocality ??
            place.thoroughfare ??
            place.name ??
            'Aniq manzil topilmadi';
      }
    } catch (e) {
      debugPrint('Fallback address error: \$e');
    }
    return LocalStorageService().getString(StorageKeys.locationName).isEmpty
        ? "O'zbekiston"
        : LocalStorageService().getString(StorageKeys.locationName);
  }
}
