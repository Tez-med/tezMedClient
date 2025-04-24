import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/request/widgets/yandex_map_service/location_service.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/presentation/request/widgets/yandex_map_service/map_service.dart';
import 'package:tez_med_client/presentation/request/widgets/yandex_map_service/search_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class YandexMapScreen extends StatefulWidget {
  const YandexMapScreen({super.key});

  @override
  State<YandexMapScreen> createState() => _YandexMapScreenState();
}

class _YandexMapScreenState extends State<YandexMapScreen> {
  final LocationService _locationService = LocationService();
  final MapService _mapService = MapService();
  final SearchService _searchService = SearchService();
  LocalStorageService localStorageService = LocalStorageService();
  Point? _selectedPoint;
  String _address = '';
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  List<SearchItem> _searchResults = [];
  Timer? _debounce;
  bool _isDragging = false;
  bool _isBottomSheetVisible = true;
  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _handleCameraMovement(
      CameraPosition position, CameraUpdateReason reason, bool finished) {
    if (reason == CameraUpdateReason.gestures) {
      setState(() => _isDragging = !finished);
      if (finished) {
        _selectedPoint = position.target;
        _updateAddressFromPoint(position.target);
      }
    }
  }

  Future<void> _updateAddressFromPoint(Point point) async {
    final address = await _searchService.getAddressFromPoint(point);
    setState(() => _address = address ?? 'Unknown location');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          YandexMap(
            onMapCreated: (controller) async {
              await _mapService.initializeMap(controller);
              _getCurrentLocation();
            },
            onCameraPositionChanged: (position, reason, finished) {
              _handleCameraMovement(position, reason, finished);
            },
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(
                    0,
                    _isDragging ? -20 : 0,
                    0,
                  ),
                  child: Assets.images.location.image(width: 40, height: 40),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => context.router.maybePop(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 50,
            left: 16,
            right: 16,
            child: _searchResults.isNotEmpty
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(top: 8),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          indent: 56,
                          color: Colors.grey.withValues(alpha: 0.15),
                        ),
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return Material(
                            color: Colors.transparent,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.blue.shade600,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                result.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                result.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              onTap: () {
                                if (result.geometry.isNotEmpty &&
                                    result.geometry[0].point != null) {
                                  _moveToPoint(result.geometry[0].point!);
                                  setState(() {
                                    _searchResults.clear();
                                    _searchController.clear();
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 68,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onTap: () {
                      setState(() {
                        _isBottomSheetVisible = false;
                      });
                    },
                    onEditingComplete: () {
                      setState(() {
                        _isBottomSheetVisible = true;
                      });
                      FocusScope.of(context).unfocus();
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: S.of(context).search_address,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade800,
                        size: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey.shade800,
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchResults.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: _searchForLocation,
                  ),
                ),
              ],
            ),
          ),

          // Map Picker

          Positioned(
            bottom: 200,
            right: 16,
            child: Visibility(
              visible: _isBottomSheetVisible,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: _getCurrentLocation,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue.shade600,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Visibility(
              visible: _isBottomSheetVisible,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.blue.shade600,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).selected_address,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _address.isEmpty
                                          ? S.of(context).no_selected_address
                                          : _address,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _selectedPoint != null && !_isLoading
                                ? () {
                                    context.router.maybePop({
                                      'address': _address,
                                      'latitude': _selectedPoint!.latitude,
                                      'longitude': _selectedPoint!.longitude,
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColor.primaryColor,
                                      ),
                                    ),
                                  )
                                : Text(
                                    S.of(context).confirm,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchForLocation(String query) async {
    setState(() => _isLoading = true);
    _searchResults = await _searchService.searchByText(
      query,
    );
    setState(() => _isLoading = false);
  }

  Future<void> _getCurrentLocation() async {
    final latitude = localStorageService.getString(StorageKeys.latitude);
    final longitude = localStorageService.getString(StorageKeys.longitude);
    if (latitude.isEmpty) {
      setState(() => _isLoading = true);

      final point = await _locationService.getCurrentLocation();
      if (point != null) {
        _selectedPoint = point;
        await _mapService.moveToPoint(point);
        _updateAddressFromPoint(point);
      }
      setState(() => _isLoading = false);
    } else {
      final point = Point(
          latitude: double.parse(latitude), longitude: double.parse(longitude));
      _selectedPoint = point;
      await _mapService.moveToPoint(point);
      _updateAddressFromPoint(point);
    }
  }

  Future<void> _getAddressFromPoint(Point point) async {
    try {
      final resultWithSession = YandexSearch.searchByPoint(
        point: point,
        searchOptions: const SearchOptions(
          searchType: SearchType.geo,
          geometry: false,
        ),
      );

      var result = await resultWithSession;
      var data = await result.$2;
      setState(() {
        _address = data.items![0].name;
      });
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
  }

  Future<void> _moveToPoint(Point point) async {
    try {
      await _mapService.moveToPoint(point);

      setState(() {
        _selectedPoint = point;
      });

      await _getAddressFromPoint(point);
    } catch (e) {
      debugPrint('Error moving to point: $e');
    }
  }
}
