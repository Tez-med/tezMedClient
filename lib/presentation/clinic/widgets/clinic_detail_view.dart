import 'package:flutter/material.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/core/widgets/raiting_stars.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/presentation/auth/widgets/button_widget.dart';
import 'package:tez_med_client/presentation/clinic/widgets/contact_button.dart';
import 'package:tez_med_client/presentation/clinic/widgets/description_section.dart';
import 'package:tez_med_client/presentation/clinic/widgets/location_section.dart';
import 'package:tez_med_client/presentation/clinic/widgets/phone_call_handler.dart';
import 'package:tez_med_client/presentation/clinic/widgets/service_section.dart';
import 'package:tez_med_client/presentation/clinic/widgets/share_section.dart';
import 'package:tez_med_client/presentation/clinic/widgets/working_hours.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ClinicDetailView extends StatefulWidget {
  final Clinic clinic;
  final YandexMapController? mapController;
  final Function(YandexMapController) onMapCreated;

  const ClinicDetailView({
    super.key,
    required this.clinic,
    required this.mapController,
    required this.onMapCreated,
  });

  @override
  State<ClinicDetailView> createState() => _ClinicDetailViewState();
}

class _ClinicDetailViewState extends State<ClinicDetailView>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  // Maksimal scroll qiymati
  final double _maxScroll = 180.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _initializeMapMarker();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Yuqoriga/pastga scroll qilishni aniqlash

    // Scroll miqdorini 0-1 orasida aniqlash
    final double scrollPercentage =
        (_scrollController.offset / _maxScroll).clamp(0.0, 1.0);

    if (_animationController.value != scrollPercentage) {
      _animationController.value = scrollPercentage;
    }
  }

  void _initializeMapMarker() {
    // Marker yaratish
    if (widget.clinic.latitude.isNotEmpty &&
        widget.clinic.longitude.isNotEmpty) {
      try {
        final point = Point(
          latitude: double.parse(widget.clinic.latitude),
          longitude: double.parse(widget.clinic.longitude),
        );

        if (widget.mapController != null) {
          widget.mapController!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: point, zoom: 15),
            ),
          );
        }
      } catch (e) {
        debugPrint('Xarita markerini yaratishda xato: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinicName = context.toLocalized(
      uz: widget.clinic.nameUz,
      ru: widget.clinic.nameRu,
      en: widget.clinic.nameEn,
    );

    final mapObjects = <MapObject>[];
    if (widget.clinic.latitude.isNotEmpty &&
        widget.clinic.longitude.isNotEmpty) {
      try {
        final point = Point(
          latitude: double.parse(widget.clinic.latitude),
          longitude: double.parse(widget.clinic.longitude),
        );

        mapObjects.add(
          PlacemarkMapObject(
            mapId: MapObjectId('clinic_${widget.clinic.id}'),
            point: point,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                    Assets.images.location.path),
                scale: .12,
              ),
            ),
            opacity: 1.0,
          ),
        );
      } catch (e) {
        debugPrint('Xarita markerini yaratishda xato: $e');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAnimatedAppBar(clinicName),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ButtonWidget(
          onPressed: () {
            PhoneCallHandler.handlePhoneCall(
              context,
              widget.clinic.phoneNumber,
            );
          },
          isLoading: false,
          consent: true,
          buttonText: "Telefon qilish",
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 230,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Klinika rasmi
                if (widget.clinic.photo.isNotEmpty &&
                    widget.clinic.photo[0].isNotEmpty)
                  CustomCachedImage(
                    image: widget.clinic.photo[0],
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.local_hospital,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                  ),

                // Qoraytirilgan gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Asosiy kontent
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 215),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),

                    // Ish vaqti
                    const SizedBox(height: 16),
                    WorkingHoursWidget(hours: widget.clinic.hours),

                    // Xizmatlar
                    const SizedBox(height: 24),
                    ServicesSection(
                        services: widget.clinic.amenities, context: context),

                    // Tavsif
                    const SizedBox(height: 24),
                    DescriptionSection(
                      description: widget.clinic.description,
                    ),

                    // Joylashuv
                    const SizedBox(height: 24),
                    LocationSection(
                      clinic: widget.clinic,
                      mapObjects: mapObjects,
                      onMapCreated: widget.onMapCreated,
                    ),

                    // Aloqa tugmalari
                    const SizedBox(height: 24),
                    ContactButtons(clinic: widget.clinic),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar(String title) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final bool showTitle = _animationController.value > .7;
          final double opacity =
              showTitle ? (_animationController.value - 0.7) * 3 : 0.0;

          return AppBar(
            backgroundColor:
                Colors.white.withValues(alpha: _animationController.value),
            centerTitle: true,
            elevation: 0,
            title: Opacity(
              opacity: opacity,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCircleButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: [
              ShareClinicSection(clinic: widget.clinic),
              SizedBox(width: 10)
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.toLocalized(
                  uz: widget.clinic.nameUz,
                  ru: widget.clinic.nameRu,
                  en: widget.clinic.nameEn,
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            PreciseRatingStars(rating: widget.clinic.rating.toDouble()),
            const SizedBox(width: 8),
            Text(
              "${widget.clinic.rating}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 20,
        padding: EdgeInsets.zero,
        onPressed: onTap,
      ),
    );
  }
}
