
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:tez_med_client/core/utils/app_color.dart';
// import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
// import 'package:tez_med_client/gen/assets.gen.dart';
// import 'package:tez_med_client/presentation/clinic_map/widgets/route_time_calculator.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

// class NavigationScreen extends StatefulWidget {
//   final Point startPoint;
//   final Point endPoint;
//   final DrivingRoute drivingRoute;
//   final Clinic clinic;

//   const NavigationScreen({
//     Key? key,
//     required this.startPoint,
//     required this.endPoint,
//     required this.drivingRoute,
//     required this.clinic,
//   }) : super(key: key);

//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen> {
//   late YandexMapController _mapController;
//   final List<MapObject> _mapObjects = [];
//   Timer? _locationUpdateTimer;
//   Position? _currentPosition;
//   final RouteTimeCalculator _routeTimeCalculator = RouteTimeCalculator();
  
//   // Yo'nalish ma'lumotlari
//   int _currentSegmentIndex = 0;
//   double _distanceToNextTurn = 0;
//   String _nextInstruction = '';
//   IconData _nextInstructionIcon = Icons.straight;
//   bool _isNavigating = false;
  
//   // Yo'nalish ma'lumotlari
//   double _totalDistance = 0;
//   int _totalTime = 0;
//   double _remainingDistance = 0;
//   int _remainingTime = 0;
  
//   @override
//   void initState() {
//     super.initState();
    
//     // Yo'nalish ma'lumotlarini o'rnatish
//     _totalDistance = widget.drivingRoute.metadata.weight.distance.value!;
//     _totalTime = widget.drivingRoute.metadata.weight.time.value!.toInt();
//     _remainingDistance = _totalDistance;
//     _remainingTime = _totalTime;
    
//     _startLocationTracking();
//   }
  
//   @override
//   void dispose() {
//     _locationUpdateTimer?.cancel();
//     super.dispose();
//   }
  
//   void _startLocationTracking() {
//     // Har 3 soniyada joylashuvni yangilash
//     _locationUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       _updateCurrentLocation();
//     });
//   }
  
//   Future<void> _updateCurrentLocation() async {
//     try {
//       final position = await Geolocator.getCurrentPosition();
//       setState(() {
//         _currentPosition = position;
//       });
      
//       // Yo'nalish ma'lumotlarini yangilash
//       if (_isNavigating) {
//         _updateNavigationInfo();
//       }
      
//       // Xaritada joylashuvni ko'rsatish
//       _updateUserLocationOnMap();
      
//       // Xaritani foydalanuvchiga focus qilish
//       _focusMapOnUser();
//     } catch (e) {
//       debugPrint('Joriy joylashuvni olishda xatolik: $e');
//     }
//   }
  
//   void _updateUserLocationOnMap() {
//     if (_currentPosition == null) return;
    
//     // Foydalanuvchi lokatsiyasi marker'i mavjud bo'lsa o'chiramiz
//     final userLocationIndex = _mapObjects
//         .indexWhere((obj) => obj.mapId == const MapObjectId('user_location'));

//     if (userLocationIndex != -1) {
//       _mapObjects.removeAt(userLocationIndex);
//     }

//     // Yangi foydalanuvchi joylashuvi markerini qo'shamiz
//     final userPoint = Point(
//       latitude: _currentPosition!.latitude,
//       longitude: _currentPosition!.longitude,
//     );

//     final userPlacemark = PlacemarkMapObject(
//       mapId: const MapObjectId('user_location'),
//       point: userPoint,
//       opacity: 1.0,
//       direction: _currentPosition!.heading.toDouble(),
//       icon: PlacemarkIcon.single(
//         PlacemarkIconStyle(
//           zIndex: 2,
//           image: BitmapDescriptor.fromAssetImage(
//             Assets.images.location.path,
//           ),
//           scale: 0.2, 
//         ),
//       ),
//     );

//     _mapObjects.add(userPlacemark);
//     setState(() {});
//   }
  
//   void _focusMapOnUser() {
//     if (_currentPosition == null || !_isNavigating) return;
    
//     _mapController.moveCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: Point(
//             latitude: _currentPosition!.latitude,
//             longitude: _currentPosition!.longitude,
//           ),
//           zoom: 17,
//           azimuth: _currentPosition!.heading.toDouble(),
//           tilt: 45,
//         ),
//       ),
//       animation: const MapAnimation(
//         type: MapAnimationType.smooth,
//         duration: 0.5,
//       ),
//     );
//   }
  
//   void _updateNavigationInfo() {
//     if (_currentPosition == null) return;
    
//     // Haqiqiy implementatsiyada bu ma'lumotlarni Yandex API dan olasiz
//     // Bu yerda simulyatsiya qilayapmiz
    
//     // Qolgan masofani hisoblash
//     final currentPoint = Point(
//       latitude: _currentPosition!.latitude,
//       longitude: _currentPosition!.longitude,
//     );
    
//     // Qolgan masofani hisoblash
//     _remainingDistance = _routeTimeCalculator.calculateDistance(
//       currentPoint, 
//       widget.endPoint
//     );
    
//     // Qolgan vaqtni taxminiy hisoblash
//     final remainingPercent = _remainingDistance / _totalDistance;
//     _remainingTime = (_totalTime * remainingPercent).round();
    
//     // Navbatdagi burilishgacha bo'lgan masofani simulyatsiya qilish
//     _distanceToNextTurn = (_remainingDistance * 0.3).clamp(50, 2000);
    
//     // Navbatdagi instruksiyani aniqlash
//     _updateNextInstruction();
    
//     setState(() {});
//   }
  
//   void _updateNextInstruction() {
//     // Burilish instruksiyalarini simulyatsiya qilish
//     // Haqiqiy implementatsiyada bu ma'lumotlarni yo'nalish API dan olasiz
    
//     final random = DateTime.now().millisecond % 4;
    
//     switch (random) {
//       case 0:
//         _nextInstruction = 'To\'g\'riga harakatlaning';
//         _nextInstructionIcon = Icons.straight;
//         break;
//       case 1:
//         _nextInstruction = 'Chapga burilish';
//         _nextInstructionIcon = Icons.turn_left;
//         break;
//       case 2:
//         _nextInstruction = 'O\'ngga burilish';
//         _nextInstructionIcon = Icons.turn_right;
//         break;
//       case 3:
//         _nextInstruction = 'Aylanma yo\'ldan chiqish';
//         _nextInstructionIcon = Icons.roundabout_right;
//         break;
//     }
//   }
  
// void _drawRoute() {
//     // Yo'nalishni chizish
//     final polyline = PolylineMapObject(
//       mapId: const MapObjectId('navigation_route'),
//       polyline: Polyline(points: widget.drivingRoute.geometry.points),
//       strokeColor: AppColor.primaryColor,
//       strokeWidth: 5.0,
//       outlineColor: Colors.white,
//       outlineWidth: 2.0,
//       turnRadius: 10.0,
//     );
    
//     // Finish point (klinika) markerini qo'shish
//     final finishPlacemark = PlacemarkMapObject(
//       mapId: const MapObjectId('destination_point'),
//       point: widget.endPoint,
//       opacity: 1.0,
//       icon: PlacemarkIcon.single(
//         PlacemarkIconStyle(
//           image: BitmapDescriptor.fromAssetImage(
//             Assets.images.clinicLocation.path,
//           ),
//           scale: 0.15,
//         ),
//       ),
//     );
    
//     _mapObjects.add(polyline);
//     _mapObjects.add(finishPlacemark);
//   }
  
//   void _toggleNavigation() {
//     setState(() {
//       _isNavigating = !_isNavigating;
//       if (_isNavigating) {
//         _focusMapOnUser();
//       }
//     });
//   }
  
//   void _showCancelNavigationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Navigatsiyani to\'xtatish'),
//         content: const Text('Navigatsiyani to\'xtatmoqchimisiz?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Yo\'q'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Dialogni yopish
//               Navigator.pop(context); // Navigatsiya ekranini yopish
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('To\'xtatish'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Xarita
//           YandexMap(
//             mapObjects: _mapObjects,
//             onMapCreated: (controller) {
//               _mapController = controller;
//               _drawRoute();
//               _updateCurrentLocation();
//             },
//           ),
          
//           // Navigatsiya paneli
//           Positioned(
//             top: MediaQuery.of(context).padding.top,
//             left: 0,
//             right: 0,
//             child: _buildNavigationPanel(),
//           ),
          
//           // Pastki panel
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: _buildBottomPanel(),
//           ),
          
//           // Navigatsiya rejimi tugmasi
//           Positioned(
//             bottom: 120,
//             right: 16,
//             child: _buildNavigationModeButton(),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildNavigationPanel() {
//     // Formatlaymiz
//     final formattedRemainingDistance = _remainingDistance < 1000
//         ? '${_remainingDistance.toStringAsFixed(0)} m'
//         : '${(_remainingDistance / 1000).toStringAsFixed(1)} km';
    
//     final formattedRemainingTime = _routeTimeCalculator.formatTime(_remainingTime);
    
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Sarlavha - klinika nomi
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: _showCancelNavigationDialog,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.close,
//                     size: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.clinic.nameUz,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           formattedRemainingDistance,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey.shade600,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Container(
//                           width: 4,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade400,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           formattedRemainingTime,
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey.shade600,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildBottomPanel() {
//     // Masofani formatlash
//     final String formattedDistanceToTurn;
//     if (_distanceToNextTurn < 100) {
//       formattedDistanceToTurn = 'Hozir';
//     } else if (_distanceToNextTurn < 1000) {
//       formattedDistanceToTurn = '${_distanceToNextTurn.toStringAsFixed(0)} m';
//     } else {
//       formattedDistanceToTurn = '${(_distanceToNextTurn / 1000).toStringAsFixed(1)} km';
//     }
    
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Burilish instruksiyasi
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: AppColor.primaryColor.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   _nextInstructionIcon,
//                   color: AppColor.primaryColor,
//                   size: 32,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       formattedDistanceToTurn,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       _nextInstruction,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Qo'shimcha knopkalar
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildActionButton(Icons.volume_up, 'Ovoz'),
//               _buildActionButton(Icons.speed, 'Tezlik'),
//               _buildActionButton(Icons.more_horiz, 'Ko\'proq'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildActionButton(IconData icon, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             color: Colors.grey.shade700,
//             size: 20,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade700,
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildNavigationModeButton() {
//     return FloatingActionButton(
//       onPressed: _toggleNavigation,
//       backgroundColor: _isNavigating ? AppColor.primaryColor : Colors.white,
//       child: Icon(
//         _isNavigating ? Icons.gps_fixed : Icons.navigation,
//         color: _isNavigating ? Colors.white : AppColor.primaryColor,
//       ),
//     );
//   }
// }