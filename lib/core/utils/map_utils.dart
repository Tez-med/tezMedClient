import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

/// A utility class for map-related operations.
/// 
/// This class follows the Single Responsibility Principle by focusing only
/// on map-related utilities, making it reusable across the app.
class MapUtils {
  
  /// Opens the most appropriate map application for navigation
  /// 
  /// This method tries to open the most appropriate map app based on the
  /// user's device and installed applications.
  /// 
  /// Parameters:
  /// - [context]: BuildContext for showing errors
  /// - [latitude]: Destination latitude
  /// - [longitude]: Destination longitude
  /// - [label]: Name of the destination (optional)
  static Future<void> openMapWithLocation({
    required BuildContext context,
    required double latitude,
    required double longitude,
    String label = 'Destination',
  }) async {
    try {
      // Create different map URIs
      final Uri androidUri = Uri.parse(
        'geo:$latitude,$longitude?q=$latitude,$longitude(${Uri.encodeComponent(label)})',
      );
      
      final Uri iosUri = Uri.parse(
        'https://maps.apple.com/?ll=$latitude,$longitude&q=${Uri.encodeComponent(label)}',
      );
      
      final Uri yandexUri = Uri.parse(
        'yandexnavi://build_route_on_map?lat_to=$latitude&lon_to=$longitude',
      );
      
      final Uri googleUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
      
      final Uri yandexMapUri = Uri.parse(
        'yandexmaps://maps.yandex.com/?pt=$longitude,$latitude&z=16',
      );
      
      // Force chooser on Android (when available)
      if (Platform.isAndroid) {
        if (await canLaunchUrl(androidUri)) {
          await launchUrl(
            androidUri,
            mode: LaunchMode.externalNonBrowserApplication,
          );
          return;
        }
      } 
      // Try Apple Maps on iOS
      else if (Platform.isIOS) {
        if (await canLaunchUrl(iosUri)) {
          await launchUrl(
            iosUri,
            mode: LaunchMode.externalNonBrowserApplication,
          );
          return;
        }
      }
      
      // Try other map apps in order of preference
      final mapOptions = [
        yandexUri,     // Yandex Navigator (most popular in Uzbekistan)
        yandexMapUri,  // Yandex Maps
        googleUri,     // Google Maps
      ];
      
      for (var uri in mapOptions) {
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalNonBrowserApplication,
          );
          return;
        }
      }
      
      // Fallback to browser-based map
      final Uri webFallback = Uri.parse(
        'https://yandex.com/maps/?pt=$longitude,$latitude&z=16',
      );
      
      await launchUrl(
        webFallback, 
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Error opening map: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xaritani ochishda xatolik: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Calculate distance between two coordinates in kilometers
  /// 
  /// Uses the Haversine formula for more accurate distance calculation
  static double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) / 1000; // Convert meters to kilometers
  }
  
  /// Format distance for display
  /// 
  /// Returns a string representation of the distance with appropriate units
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }
  
  /// Check if location services are enabled and request permission if needed
  /// 
  /// Returns true if location services are available and permission is granted
  static Future<bool> checkLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    
    // Check if permission is granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    // Check if permanently denied
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }
  
  /// Get the current user location
  /// 
  /// Returns a Position object containing lat/long coordinates
  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        return null;
      }
      
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }
  
  /// Sort a list of places by distance from current location
  /// 
  /// Requires each place to have latitude and longitude properties
  static List<T> sortByDistance<T>({
    required List<T> places,
    required double currentLat,
    required double currentLng,
    required double Function(T) getLat,
    required double Function(T) getLng,
  }) {
    final sortedPlaces = List<T>.from(places);
    
    sortedPlaces.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        currentLat,
        currentLng,
        getLat(a),
        getLng(a),
      );
      
      final distanceB = Geolocator.distanceBetween(
        currentLat,
        currentLng,
        getLat(b),
        getLng(b),
      );
      
      return distanceA.compareTo(distanceB);
    });
    
    return sortedPlaces;
  }
}