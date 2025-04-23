import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tez_med_client/core/extension/distance.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class LocationSection extends StatelessWidget {
  final Clinic clinic;
  final List<MapObject> mapObjects;
  final Function(YandexMapController) onMapCreated;

  const LocationSection({
    super.key,
    required this.clinic,
    required this.mapObjects,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    Point? mapCenter;

    if (clinic.latitude.isNotEmpty && clinic.longitude.isNotEmpty) {
      try {
        mapCenter = Point(
          latitude: double.parse(clinic.latitude),
          longitude: double.parse(clinic.longitude),
        );
      } catch (e) {
        debugPrint('Koordinatalarni aylantirish xatosi: $e');
      }
    }

    mapCenter ??= const Point(latitude: 41.2995, longitude: 69.2401);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).location,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 180,
                  child: YandexMap(
                    mapObjects: mapObjects,
                    onMapCreated: (controller) {
                      onMapCreated(controller);
                      controller.moveCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: mapCenter!,
                            zoom: 15,
                          ),
                        ),
                        animation: const MapAnimation(
                          type: MapAnimationType.smooth,
                          duration: 1.0,
                        ),
                      );
                    },
                    logoAlignment: const MapAlignment(
                      horizontal: HorizontalAlignment.right,
                      vertical: VerticalAlignment.bottom,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      clinic.address,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: FutureBuilder<String>(
                      future: _getDistance(context),
                      builder: (context, snapshot) {
                        return Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? "Masofani hisoblash..."
                                  : "${snapshot.data ?? 'Aniqlanmadi'} km",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 15, top: 5),
                    child: InkWell(
                      onTap: () {
                        _openMapWithLocation(clinic.latitude, clinic.longitude);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Yo'nalish olish",
                            style: AppTextstyle.nunitoBold.copyWith(
                              fontSize: 16,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColor.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<String> _getDistance(BuildContext context) async {
    if (clinic.latitude.isEmpty || clinic.longitude.isEmpty) {
      return 'Aniqlanmadi';
    }

    try {
      final distance = await context.distanceInKm(
        destinationLat: double.parse(clinic.latitude),
        destinationLng: double.parse(clinic.longitude),
      );

      return distance.toStringAsFixed(1);
    } catch (e) {
      debugPrint('Masofani hisoblashda xatolik: $e');
      return 'Aniqlanmadi';
    }
  }

  void _openMapWithLocation(String lat, String lon) async {
    try {
      final double latitude = double.parse(lat);
      final double longitude = double.parse(lon);
      final String label = "Manzil"; // Your desired location name

      // Create Intent for Android that forces chooser every time
      if (Platform.isAndroid) {
        // Use intent flags to force chooser every time
        final Uri androidUri = Uri.parse(
          'geo:$latitude,$longitude?q=$latitude,$longitude($label)&force_chooser=true',
        );

        await launchUrl(
          androidUri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      }
      // For iOS, we can use universal link approach
      else if (Platform.isIOS) {
        // Open Maps URL with force chooser parameter
        final Uri iosUri = Uri.parse(
          'maps://?ll=$latitude,$longitude&q=$label',
        );

        await launchUrl(
          iosUri,
          mode: LaunchMode.externalApplication,
        );
      }
      // Fallback to browser if platform-specific approach fails
      else {
        final Uri browserUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
        );
        await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Map launch error: $e');

      // If all else fails, try showing the explicit map chooser using Intent
      try {
        final mapOptions = [
          // Google Maps
          Uri.parse(
              'https://www.google.com/maps/search/?api=1&query=$lat,$lon'),
          // Yandex Maps
          Uri.parse('yandexmaps://maps.yandex.com/?pt=$lon,$lat&z=16'),
          // Yandex Navigator
          Uri.parse('yandexnavi://build_route_on_map?lat_to=$lat&lon_to=$lon'),
          // 2GIS
          Uri.parse('dgis://2gis.ru/geo/$lat,$lon'),
          // Maps.me
          Uri.parse('mapsme://map?ll=$lat,$lon&n=Location'),
        ];

        // Try each map option until one works
        for (var uri in mapOptions) {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri,
                mode: LaunchMode.externalNonBrowserApplication);
            break;
          }
        }
      } catch (e) {
        debugPrint('Fallback map launch also failed: $e');

        // Last resort: open in browser
        final Uri webFallback = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lon',
        );
        await launchUrl(webFallback, mode: LaunchMode.externalApplication);
      }
    }
  }
}
