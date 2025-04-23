import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'route_time_calculator.dart'; // RouteTimeCalculator import

class ClinicInfoBottomSheet extends StatefulWidget {
  final Clinic clinic;
  final Position? currentPosition;
  final VoidCallback onClose;
  final VoidCallback onNavigateToDetails;
  final VoidCallback onShowDirections;

  const ClinicInfoBottomSheet({
    super.key,
    required this.clinic,
    required this.currentPosition,
    required this.onClose,
    required this.onNavigateToDetails,
    required this.onShowDirections,
  });

  @override
  State<ClinicInfoBottomSheet> createState() => _ClinicInfoBottomSheetState();
}

class _ClinicInfoBottomSheetState extends State<ClinicInfoBottomSheet> {
  final RouteTimeCalculator _calculator = RouteTimeCalculator();
  Map<String, dynamic>? _routeInfo;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _calculateRouteInfo();
  }

  Future<void> _calculateRouteInfo() async {
    if (widget.currentPosition == null) return;

    setState(() => _isCalculating = true);

    try {
      final clinicLat = double.parse(widget.clinic.latitude);
      final clinicLng = double.parse(widget.clinic.longitude);

      final startPoint = Point(
        latitude: widget.currentPosition!.latitude,
        longitude: widget.currentPosition!.longitude,
      );

      final endPoint = Point(
        latitude: clinicLat,
        longitude: clinicLng,
      );

      final routeInfo = _calculator.calculateAccurateTime(startPoint, endPoint);

      setState(() {
        _routeInfo = routeInfo;
        _isCalculating = false;
      });
    } catch (e) {
      debugPrint('Yo\'nalish ma\'lumotlarini hisoblashda xatolik: $e');
      setState(() => _isCalculating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.5,
        minHeight: size.height * 0.35,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top handle for better UX
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Clinic Title & Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.toLocalized(
                      uz: widget.clinic.nameUz,
                      ru: widget.clinic.nameRu,
                      en: widget.clinic.nameEn,
                    ),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Close button with improved UI
                InkWell(
                  onTap: widget.onClose,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Clinic Address
            _buildInfoItem(
              icon: Icons.location_on,
              iconColor: AppColor.primaryColor.withOpacity(0.8),
              text: widget.clinic.address,
              fontSize: 15,
            ),

            const SizedBox(height: 12),

            // Distance and Route info section
            if (widget.currentPosition != null) ...[
              _buildDistanceInfo(),
              const SizedBox(height: 12),
              if (_isCalculating)
                const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else if (_routeInfo != null) ...[
                _buildRouteInfo(),
                const SizedBox(height: 8),
                _buildTrafficInfo(),
              ],
            ],

            const SizedBox(height: 20),

            // Action buttons with improved UI
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    iconColor: AppColor.primaryColor,
                    onPressed: widget.onShowDirections,
                    backgroundColor: Colors.blue[50]!,
                    textColor: Colors.blue[700]!,
                    iconData: Icons.directions,
                    label: S.of(context).get_directions,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    iconColor: Colors.white,
                    onPressed: widget.onNavigateToDetails,
                    backgroundColor: AppColor.primaryColor,
                    textColor: Colors.white,
                    iconData: Icons.info_outline,
                    label: S.of(context).details,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String text,
    required double fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey[800],
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceInfo() {
    try {
      if (widget.currentPosition != null) {
        final clinicLat = double.parse(widget.clinic.latitude);
        final clinicLng = double.parse(widget.clinic.longitude);

        final distanceInMeters = Geolocator.distanceBetween(
          widget.currentPosition!.latitude,
          widget.currentPosition!.longitude,
          clinicLat,
          clinicLng,
        );

        final String distance = distanceInMeters < 1000
            ? '${distanceInMeters.toStringAsFixed(0)} m'
            : '${(distanceInMeters / 1000).toStringAsFixed(1)} km';

        return _buildInfoCard(
          icon: Icons.directions_walk,
          iconColor: Colors.green[600]!,
          backgroundColor: Colors.green[50]!,
          text: '${S.of(context).distance}: $distance',
          textColor: Colors.green[700]!,
        );
      }
    } catch (e) {
      debugPrint('Masofani hisoblashda xatolik: $e');
    }

    return const SizedBox.shrink();
  }

  Widget _buildRouteInfo() {
    final timeText = _routeInfo?['formattedTime'] ?? '';

    return _buildInfoCard(
      icon: Icons.directions_car,
      iconColor: Colors.blue[600]!,
      backgroundColor: Colors.blue[50]!,
      text: '${S.of(context).travel_time}: $timeText',
      textColor: Colors.blue[700]!,
    );
  }

  Widget _buildTrafficInfo() {
    final trafficLevel = _routeInfo?['trafficLevel'] as CustomTrafficLevel?;
    final trafficStatus = _routeInfo?['trafficStatus'] as String? ?? '';

    if (trafficLevel == null) return const SizedBox.shrink();

    return _buildInfoCard(
      icon: _calculator.getTrafficIcon(trafficLevel),
      iconColor: _calculator.getTrafficColor(trafficLevel),
      backgroundColor:
          _calculator.getTrafficColor(trafficLevel).withOpacity(0.1),
      text: trafficStatus,
      textColor: _calculator.getTrafficColor(trafficLevel),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String text,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    required IconData iconData,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(iconData, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
