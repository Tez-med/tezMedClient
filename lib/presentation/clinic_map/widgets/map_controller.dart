import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/utils/map_utils.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Klinikalar xaritasi uchun controller
class ClinicsMapController {
  /// Yandex xarita controlleri
  late YandexMapController mapController;
  final Map<int, Uint8List> _clusterIconCache = {};

  /// Xaritadagi obyektlar (markerlar, yo'nalishlar)
  final List<MapObject> mapObjects = [];

  /// Foydalanuvchi joriy joylashuvi
  Position? currentPosition;

  /// Yuklanayotganlik holati
  bool isLoading = false;

  /// Foydalanuvchi joylashuvi ko'rsatilayotganini belgilaydigan flag
  bool showUserLocation = false;

  /// Joylashuvni vaqti-vaqti bilan yangilash uchun timer
  Timer? locationUpdateTimer;

  /// Barcha klinikalar ro'yxati
  List<Clinic> _allClinics = [];

  List<Clinic> _filteredClinics = [];

  /// Klinikalarni filtrlash uchun maksimal masofa (km)
  double maxDistance = 5.0;

  /// Yo'l vaqti va traffikni hisoblash uchun utility

  /// Mavjud yo'nalishlar ro'yxati
  List<DrivingRoute> availableRoutes = [];

  /// Tanlangan yo'nalish indeksi
  int selectedRouteIndex = 0;

  /// Toshkent shahrining markaziy koordinatalari (default)
  static const Point tashkentLocation = Point(
    latitude: 41.2995,
    longitude: 69.2401,
  );

  /// Controller inizializatsiyasi
  void initialize() {
    checkLocationPermission();
    startLocationUpdateTimer();
  }

  /// Controller resurslarini tozalash
  void dispose() {
    locationUpdateTimer?.cancel();
  }

  /// Joylashuvni yangilash timerini boshlash
  void startLocationUpdateTimer() {
    // Har 30 soniyada joylashuvni yangilash
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (showUserLocation) {
        getCurrentLocation();
      }
    });
  }

  /// Joylashuv ruxsatini tekshirish
  Future<void> checkLocationPermission() async {
    try {
      isLoading = true;

      final LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        final LocationPermission requestedPermission =
            await Geolocator.requestPermission();

        if (requestedPermission == LocationPermission.denied ||
            requestedPermission == LocationPermission.deniedForever) {
          showUserLocation = false;
          isLoading = false;
          return;
        }
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await getCurrentLocation();
      }
    } catch (e) {
      debugPrint('Lokatsiya ruxsatini tekshirishda xatolik: $e');
    } finally {
      isLoading = false;
    }
  }

  /// Joriy joylashuvni aniqlash
  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();

      currentPosition = position;
      showUserLocation = true;

      // Foydalanuvchi joylashuvini ko'rsatish
      updateUserLocationOnMap();
    } catch (e) {
      debugPrint('Joriy joylashuvni olishda xatolik: $e');
      showUserLocation = false;
    }
  }

  /// Foydalanuvchi joylashuvini xaritada yangilash (adaptive scaling bilan)
  Future<void> updateUserLocationOnMap() async {
    if (currentPosition == null) {
      debugPrint(
          'Foydalanuvchi lokatsiyasi aniqlanmagan, marker qo\'shilmaydi');
      return;
    }

    try {
      // Joriy zoom levelni olish

      // Foydalanuvchi lokatsiyasi marker'i mavjud bo'lsa o'chiramiz
      final userLocationIndex = mapObjects
          .indexWhere((obj) => obj.mapId == const MapObjectId('user_location'));

      if (userLocationIndex != -1) {
        mapObjects.removeAt(userLocationIndex);
      }

      // Yangi foydalanuvchi joylashuvi markerini qo'shamiz
      final userPoint = Point(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      );

      final userPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('user_location'),
        point: userPoint,
        opacity: 1.0,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            zIndex: 2,
            image: BitmapDescriptor.fromAssetImage(
              Assets.images.location.path,
            ),
            scale: .2,
          ),
        ),
      );

      mapObjects.add(userPlacemark);
      showUserLocation = true;
    } catch (e) {
      debugPrint('Foydalanuvchi joylashuvini xaritada yangilashda xatolik: $e');
    }
  }

  /// Foydalanuvchi joylashuviga yo'naltirish
  void zoomToUserLocation(BuildContext context) {
    if (currentPosition != null) {
      final userPoint = Point(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      );

      mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userPoint, zoom: 15),
        ),
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 1.0,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Joriy joylashuv aniqlanmadi'),
          duration: Duration(seconds: 2),
        ),
      );

      checkLocationPermission();
    }
  }

  /// Klinikalarni o'rnatish va ko'rsatish
  void setClinics(List<Clinic> clinics, Function(Clinic) onClinicTap) {
    _allClinics = clinics;
    _filteredClinics = clinics;
    createMapObjects(clinics, onClinicTap);
  }

  /// Klinikalarni masofa bo'yicha filtrlash
  /// Klinikalarni masofa bo'yicha filtrlash
  Future<void> filterClinicsByDistance(double distance,
      [Function(Clinic)? onClinicTap]) async {
    maxDistance = distance;
    isLoading = true; // Filtrlash jarayonini ko'rsatish

    if (currentPosition == null) {
      debugPrint('Foydalanuvchi joylashuvi aniqlanmadi, filtrlash imkonsiz');
      // Lokatsiya ruxsatini tekshirish va olishga harakat qilish
      await checkLocationPermission();

      // Agar hali ham yo'q bo'lsa
      if (currentPosition == null) {
        isLoading = false;
        // Barcha klinikalarni ko'rsatish
        _filteredClinics = _allClinics;
        if (onClinicTap != null) {
          createMapObjects(_filteredClinics, onClinicTap);
        }
        return;
      }
    }

    try {
      _filteredClinics = _allClinics.where((clinic) {
        try {
          // Koordinatalar mavjudligini tekshirish
          if (clinic.latitude.isEmpty || clinic.longitude.isEmpty) {
            return false;
          }

          // Double formatga o'tkazishdan oldin raqam ekanligini tekshirish
          final clinicLat = double.tryParse(clinic.latitude);
          final clinicLng = double.tryParse(clinic.longitude);

          // Agar koordinatalar noto'g'ri bo'lsa, bu klinikani filtrlashdan o'tkazmang
          if (clinicLat == null || clinicLng == null) {
            return false;
          }

          // Masofani hisoblash
          final distanceInMeters = Geolocator.distanceBetween(
            currentPosition!.latitude,
            currentPosition!.longitude,
            clinicLat,
            clinicLng,
          );

          final distanceInKm = distanceInMeters / 1000;
          return distanceInKm <= maxDistance;
        } catch (e) {
          debugPrint('Klinika ${clinic.id} masofasini hisoblashda xatolik: $e');
          return false; // Xatolik bo'lsa, bu klinikani ko'rsatmang
        }
      }).toList();

      debugPrint('Filtrlangan klinikalar soni: ${_filteredClinics.length}');

      // Marker'larni yangilash
      if (onClinicTap != null) {
        createMapObjects(_filteredClinics, onClinicTap);
      }

      // Xaritani yangi chegaralarga moslashtirish
      if (_filteredClinics.isNotEmpty) {
        moveToClinicsBounds(_filteredClinics);
      } else {
        // Agar filtrlash natijasida klinikalar topilmasa, bu haqda xabar berish kerak
        debugPrint('Berilgan radius ichida klinikalar topilmadi');
        // Realniy holatda bu yerda UI orqali foydalanuvchiga xabar berish kerak
      }
    } catch (e) {
      debugPrint('Filtrlashda kutilmagan xato: $e');
    } finally {
      isLoading =
          false; // Filtrlash tugagandan so'ng yuklanish holatini o'chirish
    }
  }

  /// Xaritada klinika markerlarini yaratish
  void createMapObjects(
      List<Clinic> clinics, Function(Clinic) onClinicTap) async {
    mapObjects
        .removeWhere((obj) => obj.mapId != const MapObjectId('user_location'));

    if (clinics.isEmpty) {
      return;
    }

    final List<PlacemarkMapObject> placemarks = [];

    for (final clinic in clinics) {
      if (clinic.latitude.isNotEmpty && clinic.longitude.isNotEmpty) {
        try {
          final latitude = double.parse(clinic.latitude);
          final longitude = double.parse(clinic.longitude);

          final placemark = PlacemarkMapObject(
            mapId: MapObjectId('clinic_${clinic.id}'),
            point: Point(latitude: latitude, longitude: longitude),
            opacity: 1.0,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  Assets.images.clinicLocation.path,
                ),
                scale: 0.3,
              ),
            ),
            onTap: (_, __) => onClinicTap(clinic),
          );

          placemarks.add(placemark);
        } catch (e) {
          debugPrint('Klinika koordinatalari xatosi: ${clinic.id} - $e');
        }
      }
    }

    if (placemarks.isNotEmpty) {
      // Joriy zoom levelni olamiz

      // Zoom levelga mos radius hisoblaymiz

      final clusterizedCollection = ClusterizedPlacemarkCollection(
        mapId: const MapObjectId('clinics_cluster'),
        radius: 100,
        minZoom: 15,
        placemarks: placemarks,
        onClusterAdded: (self, cluster) async {
          final bytes = await _getClusterIconBytes(cluster.size);
          return cluster.copyWith(
            appearance: cluster.appearance.copyWith(
              opacity: 1.0,
              zIndex: 100,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromBytes(bytes),
                  scale: 1.0,
                ),
              ),
            ),
          );
        },
        onClusterTap: (self, cluster) async {
          final currentZoom = (await mapController.getCameraPosition()).zoom;
          await mapController.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: cluster.appearance.point,
                zoom: (currentZoom + 3).clamp(0, 21),
              ),
            ),
            animation: const MapAnimation(
              type: MapAnimationType.smooth,
              duration: 0.5,
            ),
          );
        },
      );

      mapObjects.add(clusterizedCollection);
    }
  }

  /// Klaster ikonasini chizish va cache’lash
  Future<Uint8List> _getClusterIconBytes(int size) async {
    final key = size > 99 ? 100 : size;

    // Cache'dan olishga harakat qilamiz
    if (_clusterIconCache.containsKey(key)) {
      return _clusterIconCache[key]!;
    }

    const double radius = 40.0;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
    canvas.drawCircle(Offset(radius + 1, radius + 2), radius, shadowPaint);

    // Gradient background
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF4444),
          const Color(0xFFCC0000),
        ],
        stops: const [0.0, 1.0],
      ).createShader(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius));

    canvas.drawCircle(Offset(radius, radius), radius, gradientPaint);

    // White border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(Offset(radius, radius), radius - 2, borderPaint);

    // Number text
    final textSpan = TextSpan(
      text: size > 99 ? '99+' : size.toString(),
      style: TextStyle(
        color: Colors.white,
        fontSize: size > 99 ? 18 : 24,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black54)
        ],
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final image =
        await picture.toImage((radius * 2).toInt(), (radius * 2).toInt());
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    if (byteData != null) {
      final bytes = byteData.buffer.asUint8List();
      _clusterIconCache[key] = bytes;
      return bytes;
    }

    throw Exception('Failed to create cluster icon');
  }

  /// Klinikalar chegarasiga xarita ko'rinishini moslashtirish
  void moveToClinicsBounds(List<Clinic> clinics) {
    // Barcha klinikalarni o'z ichiga oluvchi chegaralarni hisoblash
    final List<Point> points = [];

    // Klinika nuqtalarini qo'shamiz
    for (final clinic in clinics) {
      if (clinic.latitude.isNotEmpty && clinic.longitude.isNotEmpty) {
        try {
          final latitude = double.parse(clinic.latitude);
          final longitude = double.parse(clinic.longitude);
          points.add(Point(latitude: latitude, longitude: longitude));
        } catch (e) {
          debugPrint('Koordinatalarni aylantirish xatosi: $e');
        }
      }
    }

    // Foydalanuvchi joylashuvini ham qo'shamiz (agar mavjud bo'lsa)
    if (showUserLocation && currentPosition != null) {
      points.add(Point(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      ));
    }

    if (points.isEmpty) {
      // Agar hech qanday valid nuqta topilmasa, default manzilga o'tamiz
      mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(target: tashkentLocation, zoom: 12),
        ),
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 1.0,
        ),
      );
      return;
    }

    // Barcha nuqtalar uchun BoundingBox yaratamiz
    double minLat = 90, maxLat = -90, minLon = 180, maxLon = -180;

    for (final point in points) {
      minLat = math.min(point.latitude, minLat);
      maxLat = math.max(point.latitude, maxLat);
      minLon = math.min(point.longitude, minLon);
      maxLon = math.max(point.longitude, maxLon);
    }

    // Chegaralarni kengaytiramiz (padding)
    const padding = 0.02; // ~2km
    minLat -= padding;
    maxLat += padding;
    minLon -= padding;
    maxLon += padding;

    final southWest = Point(latitude: minLat, longitude: minLon);
    final northEast = Point(latitude: maxLat, longitude: maxLon);

    // BoundingBox ga o'tamiz
    mapController.moveCamera(
      CameraUpdate.newBounds(
        BoundingBox(northEast: northEast, southWest: southWest),
      ),
      animation: const MapAnimation(
        type: MapAnimationType.smooth,
        duration: 1.0,
      ),
    );
  }

  /// Klinikaga xaritada fokuslanish
  void focusOnClinic(Clinic clinic) {
    try {
      final latitude = double.parse(clinic.latitude);
      final longitude = double.parse(clinic.longitude);

      mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: latitude, longitude: longitude),
            zoom: 15,
          ),
        ),
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 1.0,
        ),
      );
    } catch (e) {
      debugPrint('Klinikaga o\'tishda xatolik: $e');
    }
  }

  /// Telefon xarita ilovasida yo'nalish ko'rsatish
  void openMapForDirections(BuildContext context, Clinic clinic) {
    try {
      final latitude = double.parse(clinic.latitude);
      final longitude = double.parse(clinic.longitude);

      final clinicName = context.toLocalized(
        uz: clinic.nameUz,
        ru: clinic.nameRu,
        en: clinic.nameEn,
      );

      MapUtils.openMapWithLocation(
        context: context,
        latitude: latitude,
        longitude: longitude,
        label: clinicName,
      );
    } catch (e) {
      debugPrint('Yo\'l ko\'rsatishda xatolik: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yo\'l ko\'rsatishda xatolik yuz berdi'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Klinikagacha masofani hisoblash
  double calculateDistance(Clinic clinic) {
    try {
      if (currentPosition != null &&
          clinic.latitude.isNotEmpty &&
          clinic.longitude.isNotEmpty) {
        final clinicLat = double.parse(clinic.latitude);
        final clinicLng = double.parse(clinic.longitude);

        return Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          clinicLat,
          clinicLng,
        );
      }
    } catch (e) {
      debugPrint('Masofani hisoblashda xatolik: $e');
    }
    return -1;
  }

  /// Yo'lning to'liq ko'rinishi uchun xaritani moslashtirish
  void adjustMapToShowFullRoute() {
    if (availableRoutes.isEmpty || currentPosition == null) {
      return;
    }

    try {
      // Barcha yo'nalish nuqtalarini yig'ish
      final List<Point> allRoutePoints = [];

      // Foydalanuvchi nuqtasini qo'shamiz
      final userPoint = Point(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      );
      allRoutePoints.add(userPoint);

      // Tanlangan yo'nalish nuqtalarini qo'shamiz
      final selectedRoute = availableRoutes[selectedRouteIndex];
      allRoutePoints.addAll(selectedRoute.geometry.points);

      // Barcha nuqtalar uchun BoundingBox yaratamiz
      double minLat = 90, maxLat = -90, minLon = 180, maxLon = -180;

      for (final point in allRoutePoints) {
        minLat = math.min(point.latitude, minLat);
        maxLat = math.max(point.latitude, maxLat);
        minLon = math.min(point.longitude, minLon);
        maxLon = math.max(point.longitude, maxLon);
      }

      // Chegaralarni kengaytiramiz (padding)
      const padding = 0.01; // ~1km
      minLat -= padding;
      maxLat += padding;
      minLon -= padding;
      maxLon += padding;

      final southWest = Point(latitude: minLat, longitude: minLon);
      final northEast = Point(latitude: maxLat, longitude: maxLon);

      // BoundingBox ga o'tamiz - butun yo'nalish ko'rinadi
      mapController.moveCamera(
        CameraUpdate.newBounds(
          BoundingBox(northEast: northEast, southWest: southWest),
        ),
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 0.5,
        ),
      );
    } catch (e) {
      debugPrint('Xaritani moslashtirishda xatolik: $e');
    }
  }
}
