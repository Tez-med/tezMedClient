import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Traffic darajasini ifodalovchi enum
enum CustomTrafficLevel {
  /// Kam traffic - tezlik koeffitsienti: 1.0
  low,
  
  /// O'rtacha traffic - tezlik koeffitsienti: 0.8
  medium,
  
  /// Yuqori traffic - tezlik koeffitsienti: 0.6
  high,
  
  /// Juda yuqori traffic/probka - tezlik koeffitsienti: 0.4
  veryHigh
}

/// Yo'nalish vaqti va traffic holatini hisoblash uchun servis
class RouteTimeCalculator {
  // Singleton patternni qo'llash
  static final RouteTimeCalculator _instance = RouteTimeCalculator._internal();
  
  /// RouteTimeCalculator factory konstruktori - singleton pattern
  factory RouteTimeCalculator() => _instance;
  
  /// Private konstruktor
  RouteTimeCalculator._internal();
  
  /// Yo'l turlari konstanta map'i
  static const Map<String, double> _roadSpeedLimits = {
    'highway': 110.0,  // Magistral yo'l (km/soat)
    'suburban': 90.0,  // Shahar tashqarisidagi yo'l (km/soat)
    'city': 60.0,      // Shahar ichidagi yo'l (km/soat)
    'district': 40.0,  // Tumandagi yo'l (km/soat)
    'alley': 20.0,     // Tor ko'cha (km/soat)
  };
  
  /// Traffic darajasi koeffitsientlari
  static const Map<CustomTrafficLevel, double> _trafficCoefficients = {
    CustomTrafficLevel.low: 1.0,
    CustomTrafficLevel.medium: 0.8,
    CustomTrafficLevel.high: 0.6,
    CustomTrafficLevel.veryHigh: 0.4,
  };
  
  /// Traffic darajasi matnlari
  static const Map<CustomTrafficLevel, String> _trafficStatusTexts = {
    CustomTrafficLevel.low: 'Yo\'llarda harakat erkin',
    CustomTrafficLevel.medium: 'O\'rtacha harakat',
    CustomTrafficLevel.high: 'Yo\'llarda tiqin',
    CustomTrafficLevel.veryHigh: 'Kuchli tiqin',
  };
  
  /// Traffic darajasi ranglari
  static const Map<CustomTrafficLevel, Color> _trafficColors = {
    CustomTrafficLevel.low: Colors.green,
    CustomTrafficLevel.medium: Colors.orange,
    CustomTrafficLevel.high: Colors.deepOrange,
    CustomTrafficLevel.veryHigh: Colors.red,
  };

  /// Joriy traffic darajasini olish
  ///
  /// Vaqt va hafta kuniga qarab traffic darajasini aniqlaydi.
  /// Haqiqiy implementatsiyada bu Yandex Maps API'dan olinadi.
  CustomTrafficLevel getCurrentTrafficLevel() {
    final now = DateTime.now();
    final hour = now.hour;
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    
    // Dam olish kunlari
    if (weekday >= 6) { // Shanba yoki Yakshanba
      return _getWeekendTrafficLevel(hour);
    }
    
    // Ish kunlari
    return _getWorkdayTrafficLevel(hour);
  }
  
  /// Dam olish kunlaridagi traffic darajasini aniqlash
  CustomTrafficLevel _getWeekendTrafficLevel(int hour) {
    if (hour >= 12 && hour <= 18) {
      return CustomTrafficLevel.medium; // Kunduzi o'rtacha
    } 
    return CustomTrafficLevel.low; // Ertalab/kechqurun kam
  }

  /// Ish kunlaridagi traffic darajasini aniqlash
  CustomTrafficLevel _getWorkdayTrafficLevel(int hour) {
    if ((hour >= 7 && hour <= 10) || (hour >= 17 && hour <= 19)) {
      return CustomTrafficLevel.veryHigh; // Rush hours
    } 
    
    if ((hour >= 11 && hour <= 16) || (hour >= 20 && hour <= 22)) {
      return CustomTrafficLevel.medium; // Regular hours
    }
    
    return CustomTrafficLevel.low; // Night hours
  }

  /// Traffic darajasiga ko'ra koeffitsient olish
  double getTrafficCoefficient(CustomTrafficLevel level) => 
      _trafficCoefficients[level] ?? 1.0;

  /// Yo'l turiga ko'ra tezlik chegarasini olish
  double getSpeedLimit(String roadType) => 
      _roadSpeedLimits[roadType] ?? 50.0; // Default 50 km/h

  /// Yo'nalish ma'lumotlarini olish
  ///
  /// Bu simulyatsiya qilingan metod. Haqiqiy holatda 
  /// Yandex Maps API'dan olinadi.
  Map<String, dynamic> getRouteDetails(Point start, Point end) {
    final distanceInMeters = calculateDistance(start, end);
    final roadSegments = _generateRoadSegments(distanceInMeters);
    
    return {
      'distance': distanceInMeters,
      'roadSegments': roadSegments,
    };
  }
  
  /// Masofa asosida yo'l segmentlarini generatsiya qilish
  List<Map<String, dynamic>> _generateRoadSegments(double distanceInMeters) {
    if (distanceInMeters > 10000) {
      return _generateLongRouteSegments(distanceInMeters);
    } 
    
    if (distanceInMeters > 5000) {
      return _generateMediumRouteSegments(distanceInMeters);
    } 
    
    if (distanceInMeters > 2000) {
      return _generateShortRouteSegments(distanceInMeters);
    }
    
    return _generateVeryShortRouteSegments(distanceInMeters);
  }
  
  /// 10km dan ortiq yo'l segmentlari
  List<Map<String, dynamic>> _generateLongRouteSegments(double distance) => [
    {'type': 'city', 'distance': distance * 0.2},
    {'type': 'highway', 'distance': distance * 0.6},
    {'type': 'city', 'distance': distance * 0.2},
  ];
  
  /// 5-10km yo'l segmentlari
  List<Map<String, dynamic>> _generateMediumRouteSegments(double distance) => [
    {'type': 'district', 'distance': distance * 0.3},
    {'type': 'city', 'distance': distance * 0.5},
    {'type': 'district', 'distance': distance * 0.2},
  ];
  
  /// 2-5km yo'l segmentlari
  List<Map<String, dynamic>> _generateShortRouteSegments(double distance) => [
    {'type': 'district', 'distance': distance * 0.2},
    {'type': 'city', 'distance': distance * 0.8},
  ];
  
  /// 2km dan kam yo'l segmentlari
  List<Map<String, dynamic>> _generateVeryShortRouteSegments(double distance) => [
    {'type': 'district', 'distance': distance * 0.7},
    {'type': 'alley', 'distance': distance * 0.3},
  ];

  /// Qo'shimcha vaqt hisoblagich - chorraha, svetofor va boshqalar
  ///
  /// [distanceInKm] - kilometrlardagi masofa
  /// Har 1km masofada o'rtacha 1 ta svetofor/chorraha deb hisoblaymiz
  int calculateAdditionalTime(double distanceInKm) {
    final intersections = distanceInKm.ceil();
    final waitTimePerIntersection = 30; // soniyalarda
    return intersections * waitTimePerIntersection;
  }

  /// Yo'nalish vaqtini aniq hisoblash
  ///
  /// [start] va [end] nuqtalar orasidagi yo'nalish vaqtini 
  /// traffic holatini hisobga olgan holda qaytaradi
  Map<String, dynamic> calculateAccurateTime(Point start, Point end) {
    // Yo'nalish ma'lumotlarini olish
    final routeDetails = getRouteDetails(start, end);
    final roadSegments = routeDetails['roadSegments'] as List<Map<String, dynamic>>;
    
    // Joriy traffic holatini aniqlash
    final trafficLevel = getCurrentTrafficLevel();
    final trafficCoefficient = getTrafficCoefficient(trafficLevel);
    final trafficStatus = _trafficStatusTexts[trafficLevel]!;
    
    final result = _calculateSegmentTimes(
      roadSegments: roadSegments, 
      trafficCoefficient: trafficCoefficient
    );
    
    final totalTimeSeconds = _applyTimeVariability(
      result['totalTimeSeconds'] as int,
      result['totalDistanceKm'] as double,
    );
    
    final formattedTime = _formatTime(totalTimeSeconds);
    
    return {
      'timeInSeconds': totalTimeSeconds,
      'formattedTime': formattedTime,
      'trafficStatus': trafficStatus,
      'trafficLevel': trafficLevel,
    };
  }
  
  /// Yo'l segmentlari vaqtini hisoblash
  Map<String, dynamic> _calculateSegmentTimes({
    required List<Map<String, dynamic>> roadSegments,
    required double trafficCoefficient,
  }) {
    int totalTimeSeconds = 0;
    double totalDistanceKm = 0;
    
    for (final segment in roadSegments) {
      final segmentType = segment['type'] as String;
      final segmentDistance = segment['distance'] as double;
      final segmentDistanceKm = segmentDistance / 1000;
      
      totalDistanceKm += segmentDistanceKm;
      
      // Yo'l turi uchun maks tezlikni olish
      final speedLimit = getSpeedLimit(segmentType);
      
      // Traffic holatiga ko'ra haqiqiy tezlikni hisoblash
      final actualSpeed = speedLimit * trafficCoefficient;
      
      // Vaqtni hisoblash (soatlarda) -> soniyalarga aylantiramiz
      final timeHours = segmentDistanceKm / actualSpeed;
      final timeSeconds = (timeHours * 3600).round();
      
      totalTimeSeconds += timeSeconds;
    }
    
    // Qo'shimcha vaqtni hisoblash (svetofor, chorraha, parkovka qidirish)
    final additionalSeconds = calculateAdditionalTime(totalDistanceKm);
    totalTimeSeconds += additionalSeconds;
    
    return {
      'totalTimeSeconds': totalTimeSeconds,
      'totalDistanceKm': totalDistanceKm,
    };
  }
  
  /// Vaqtga variatsiya qo'shish
  ///
  /// Haqiqiy yo'l harakat vaqtida tasodifiy o'zgarishlarni simulyatsiya qilish
  int _applyTimeVariability(int totalTimeSeconds, double totalDistanceKm) {
    // Random variability (5% gacha)
    final random = Random();
    final variabilityFactor = 0.95 + (random.nextDouble() * 0.1); // 0.95-1.05
    return (totalTimeSeconds * variabilityFactor).round();
  }
  
  /// Vaqtni formatlash 
  String _formatTime(int totalTimeSeconds) {
    final hours = totalTimeSeconds ~/ 3600;
    final minutes = (totalTimeSeconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '$hours soat ${minutes > 0 ? '$minutes daq' : ''}';
    } 
    return '$minutes daq';
  }

  /// Ikki nuqta orasidagi masofani hisoblash (metrda)
  double calculateDistance(Point point1, Point point2) {
    try {
      return Geolocator.distanceBetween(
        point1.latitude,
        point1.longitude,
        point2.latitude,
        point2.longitude,
      );
    } catch (e) {
      debugPrint('Masofani hisoblashda xatolik: $e');
      return 0;
    }
  }
  
  /// Traffic darajasiga mos rangni qaytarish
  Color getTrafficColor(CustomTrafficLevel level) => 
      _trafficColors[level] ?? Colors.grey;
  
  /// Traffic darajasiga mos ikonkani qaytarish
  IconData getTrafficIcon(CustomTrafficLevel level) {
    switch (level) {
      case CustomTrafficLevel.low:
        return Icons.traffic_outlined;
      case CustomTrafficLevel.medium:
        return Icons.traffic;
      case CustomTrafficLevel.high:
        return Icons.warning;
      case CustomTrafficLevel.veryHigh:
        return Icons.warning_amber;
    }
  }
  
  /// Traffic holatini matn ko'rinishida qaytarish
  String getTrafficStatus(CustomTrafficLevel level) => 
      _trafficStatusTexts[level] ?? 'Noma\'lum';
      
  /// Vaqtni odam o'qiy oladigan formatga o'tkazish
  String formatTime(int totalTimeSeconds) {
    return _formatTime(totalTimeSeconds);
  }
  
  /// Yo'nalish vaqtidan traffic darajasini aniqlash
  ///
  /// [timeInSeconds] - yo'nalish vaqti (soniyada)
  /// [distance] - masofa (metrda)
  CustomTrafficLevel getTrafficLevelFromRouteTime(int timeInSeconds, double distance) {
    // Masofani metrdan kilometrga o'tkazamiz
    final distanceKm = distance / 1000;
    
    // O'rtacha tezlikni hisoblash (km/soat)
    final hours = timeInSeconds / 3600;
    final averageSpeed = distanceKm / hours;
    
    // Trafikni o'rtacha tezlikka qarab aniqlash
    if (averageSpeed > 45) {
      return CustomTrafficLevel.low;
    } 
    
    if (averageSpeed > 25) {
      return CustomTrafficLevel.medium;
    } 
    
    if (averageSpeed > 10) {
      return CustomTrafficLevel.high;
    } 
    
    return CustomTrafficLevel.veryHigh;
  }
}