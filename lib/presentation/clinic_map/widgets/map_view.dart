import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/presentation/clinic_map/widgets/map_controller.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapView extends StatefulWidget {
  final List<Clinic> clinics;
  final ClinicsMapController mapController;
  final Function(Clinic) onClinicTap;
  final VoidCallback onShowSearchDialog;

  const MapView({
    super.key,
    required this.clinics,
    required this.mapController,
    required this.onClinicTap,
    required this.onShowSearchDialog,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    debugPrint('MapView qurilmoqda. Klinikalar soni: ${widget.clinics.length}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Widget qurilgandan keyin, foydalanuvchi lokatsiyasini yangilaymiz
      if (widget.mapController.currentPosition != null) {
        debugPrint(
            'Post-frame callback: foydalanuvchi lokatsiyasini yangilash');
        widget.mapController.updateUserLocationOnMap();
      }
    });

    return Stack(
      children: [
        YandexMap(
          mapObjects: widget.mapController.mapObjects,
          
          onMapCreated: (controller) {
            debugPrint('Xarita yaratildi');
            widget.mapController.mapController = controller;

            // Barcha markerlarni yangilash
            debugPrint('Klinika markerlari chizilmoqda...');
            widget.mapController
                .createMapObjects(widget.clinics, widget.onClinicTap);

            // Foydalanuvchi lokatsiyasini ko'rsatish (muhim!)
            Future.delayed(const Duration(milliseconds: 500), () {
              debugPrint(
                  '500ms kechikish bilan foydalanuvchi joylashuvini yangilash');
              widget.mapController.updateUserLocationOnMap();

              // Barchasi ko'rinadigan qilib xaritani moslash
              if (widget.clinics.isNotEmpty) {
                debugPrint('Klinikalar chegaralariga fokuslanish...');
                widget.mapController.moveToClinicsBounds(widget.clinics);
              } else {
                debugPrint(
                    'Klinikalar bo\'sh, default manzilga fokuslanish...');
                controller.moveCamera(
                  CameraUpdate.newCameraPosition(
                    const CameraPosition(
                      target: ClinicsMapController.tashkentLocation,
                      zoom: 12,
                    ),
                  ),
                );
              }
            });
          },
        ),

        // Aktiv filter badge
        if (widget.mapController.maxDistance != 5.0)
          Positioned(
            top: 76,
            left: 16,
            child: InkWell(
              onTap: () {
                // Filter badge'ga bosilganda uning o'zini ochish
                widget.mapController.maxDistance = 5.0;
                if (widget.clinics.length < 3) {
                  // Refresh UI
                  (context as Element).markNeedsBuild();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.filter_alt,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.mapController.maxDistance.toInt()} km',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Control buttons
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // My location button
              FloatingActionButton(
                heroTag: "btnMyLocation",
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () =>
                    widget.mapController.zoomToUserLocation(context),
                tooltip: 'Mening joylashuvim',
                child: Icon(
                  Icons.my_location,
                  color: widget.mapController.showUserLocation
                      ? AppColor.primaryColor
                      : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Show all clinics button
              FloatingActionButton(
                heroTag: "btnAllClinics",
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () =>
                    widget.mapController.moveToClinicsBounds(widget.clinics),
                tooltip: 'Barcha klinikalar',
                child: const Icon(Icons.map, color: Colors.blue),
              ),
            ],
          ),
        ),

        // Search bar
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: _buildSearchBar(),
        ),

        // Klinikalar soni badge
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Ko\'rsatilmoqda: ${widget.clinics.length} klinika',
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.onShowSearchDialog,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Text(
                  'Klinika qidirish',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
