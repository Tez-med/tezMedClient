import 'package:flutter/material.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/request/widgets/yandex_map_service/location_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class LocationSelectorButton extends StatefulWidget {
  final Function(Point location) onLocationSelected;
  final LocationService locationService;

  const LocationSelectorButton({
    super.key,
    required this.onLocationSelected,
    required this.locationService,
  });

  @override
  State<LocationSelectorButton> createState() => _LocationSelectorButtonState();
}

class _LocationSelectorButtonState extends State<LocationSelectorButton> {
  bool _isLoading = false;
  Point? _selectedLocation;
  String? address;
  LocalStorageService localStorageService = LocalStorageService();

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final location = await widget.locationService.getCurrentLocation();

      if (location != null) {
        address =
            await widget.locationService.getAddressFromCoordinates(location);

        setState(() {
          _selectedLocation = location;
        });
        localStorageService.setString(StorageKeys.locationName, address ?? "");
        localStorageService.setString(
            StorageKeys.latitude, location.latitude.toString());
        localStorageService.setString(
            StorageKeys.longitude, location.longitude.toString());
        widget.onLocationSelected(location);
        AnimatedCustomSnackbar.show(
          context: context,
          message: S.of(context).location_successfully,
          type: SnackbarType.success,
        );
      } else {
        AnimatedCustomSnackbar.show(
          context: context,
          message: S.of(context).location_error,
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      AnimatedCustomSnackbar.show(
        context: context,
        message: S.of(context).unexpected_error,
        type: SnackbarType.success,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).location,
          style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading ? null : _getCurrentLocation,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: _selectedLocation != null
                          ? Colors.green
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedLocation != null
                            ? S.of(context).location_selected
                            : S.of(context).select_location,
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedLocation != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    else
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_selectedLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              address ?? "",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }
}
