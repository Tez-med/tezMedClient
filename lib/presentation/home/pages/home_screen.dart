import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/constant/app_update_manager.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/home/pages/species_screen.dart';
import 'package:tez_med_client/presentation/notification/bloc/notification_bloc.dart';
import 'package:tez_med_client/presentation/request/widgets/yandex_map_service/location_service.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UpdateManager updateManager = UpdateManager();

  ValueNotifier<bool> isSearchVisible = ValueNotifier(true);
  ValueNotifier<String?> locationNameNotifier = ValueNotifier(null);

  late final LocalStorageService _localStorageService;
  StreamSubscription? _locationSubscription;

  @override
  void initState() {
    super.initState();
    updateManager.checkForUpdate();

    _localStorageService = LocalStorageService();
    _initializeLocation();

    // SharedPreferences-dagi lokatsiyani doimiy kuzatamiz
    _listenForLocationChanges();
  }

  void _listenForLocationChanges() {
    _locationSubscription =
        Stream.periodic(const Duration(seconds: 2)).listen((_) {
      final savedLocation =
          _localStorageService.getString(StorageKeys.locationName);
      if (savedLocation.isNotEmpty &&
          locationNameNotifier.value != savedLocation) {
        locationNameNotifier.value = savedLocation;
      }
    });
  }

  Future<void> _initializeLocation() async {
    try {
      // Avval saqlangan lokatsiyani olish
      String? savedLocation =
          _localStorageService.getString(StorageKeys.locationName);

      if (savedLocation.isNotEmpty) {
        locationNameNotifier.value = savedLocation;
        return; 
      }

      final locationService = LocationService();
      final point = await locationService.getCurrentLocation();

      if (point != null) {
        final address = await locationService.getAddressFromCoordinates(point);
        if (address != null && address.isNotEmpty) {
          _localStorageService.setString(StorageKeys.locationName, address);
          locationNameNotifier.value = address;
        }
      } else {
        locationNameNotifier.value = S.of(context).location_detecting;
      }
    } catch (e) {
      locationNameNotifier.value = S.of(context).location_detecting;
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: AppColor.buttonBackColor,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).address,
              style: TextStyle(color: AppColor.greyTextColor, fontSize: 12),
            ),
            _buildLocationBar(),
          ],
        ),
        actions: [_buildNotificationButton()],
      ),
      body: SpeciesScreen(),
    );
  }

  Widget _buildLocationBar() {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<String?>(
            valueListenable: locationNameNotifier,
            builder: (context, locationName, child) {
              return Text(
                locationName ?? "Lokatsiya tanlanmagan",
                style: AppTextstyle.nunitoMedium.copyWith(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        // const Icon(Icons.keyboard_arrow_down_rounded)
      ],
    );
  }

  int _getUnreadCount(NotificationsLoaded state) {
    final userId = LocalStorageService().getString(StorageKeys.userId);
    return state.notifications
        .where((n) => n.userId == userId && !n.isRead)
        .length;
  }

  Widget _buildNotificationIcon(bool hasUnread) {
    final notificationIcon = Assets.icons.notification.svg();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        notificationIcon,
        if (hasUnread)
          Positioned(
            top: -2,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationsLoaded) {
          final hasUnread = _getUnreadCount(state) > 0;
          return IconButton(
            padding: const EdgeInsets.all(8),
            onPressed: () => context.router.push(const NotificationRoute()),
            icon: _buildNotificationIcon(hasUnread),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
