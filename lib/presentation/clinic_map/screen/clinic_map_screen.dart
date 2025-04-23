import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/presentation/clinic/bloc/clinic_bloc.dart';
import 'package:tez_med_client/presentation/clinic_map/widgets/clinic_filter_dialog.dart';
import 'package:tez_med_client/presentation/clinic_map/widgets/clinic_info_bottom.dart';
import 'package:tez_med_client/presentation/clinic_map/widgets/clinic_search_dialog.dart';
import 'package:tez_med_client/presentation/clinic_map/widgets/error_view.dart';
import 'package:tez_med_client/presentation/clinic_map/widgets/map_controller.dart';
import 'package:tez_med_client/presentation/clinic_map/widgets/map_view.dart';

@RoutePage()
class ClinicsMapScreen extends StatefulWidget {
  const ClinicsMapScreen({super.key});

  @override
  State<ClinicsMapScreen> createState() => _ClinicsMapScreenState();
}

class _ClinicsMapScreenState extends State<ClinicsMapScreen>
    with WidgetsBindingObserver {
  final ClinicsMapController _mapController = ClinicsMapController();
  Clinic? _selectedClinic;

  // Klinikalar listlari
  List<Clinic> _allClinics = [];
  List<Clinic> _filteredClinics = [];
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Controller'ni ishga tushirish
    _initializeController();
  }

  Future<void> _initializeController() async {
    debugPrint('Map controller ishga tushirilmoqda...');
    _mapController.initialize();

    // Ekranga kirganimizda ham foydalanuvchi lokatsiyasini yangilaymiz
    if (_mapController.currentPosition != null) {
      debugPrint('Lokatsiya initializatsiyada aniqlandi, yangilanmoqda...');
      _mapController.updateUserLocationOnMap();
    } else {
      debugPrint(
          'Lokatsiya initializatsiyada aniqlanmadi, ruxsat so\'ralmoqda...');
      await _mapController.checkLocationPermission();

      // Yana bir marta tekshiramiz
      if (_mapController.currentPosition != null) {
        debugPrint('Lokatsiya so\'rovdan keyin aniqlandi, yangilanmoqda...');
        _mapController.updateUserLocationOnMap();
      }
    }

    if (mounted) {
      setState(() {
        // Controllerni ishga tushirish tugadi
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController.dispose();
    super.dispose();
  }

  void _onClinicSelected(Clinic clinic) {
    setState(() {
      _selectedClinic = clinic;
    });
    _mapController.focusOnClinic(clinic);
  }

  void _closeClinicInfo() {
    setState(() {
      _selectedClinic = null;
    });
  }

  void _navigateToClinicDetails(Clinic clinic) {
    context.router.push(
      ClinicDetailsRoute(
        clinicId: clinic.id,
      ),
    );
  }

  void _showSearchDialog(List<Clinic> clinics) {
    showDialog(
      context: context,
      builder: (context) => ClinicSearchDialog(
        clinics: clinics,
        onClinicSelected: _onClinicSelected,
      ),
    );
  }

  void _showFilterDialog() {
    if (_mapController.currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Joylashuvingiz aniqlanmadi. Avval joylashuvga ruxsat bering.'),
          duration: Duration(seconds: 3),
        ),
      );
      _mapController.checkLocationPermission();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ClinicFilterDialog(
        initialDistance: _mapController.maxDistance,
        onApplyFilter: (maxDistance) {
          debugPrint('Filtrlash boshlanmoqda: $maxDistance km');

          // Filtrlash va UI yangilash
          final filteredClinics =
              _filterClinicsByDistance(_allClinics, maxDistance);

          setState(() {
            _filteredClinics = filteredClinics;
            _mapController.maxDistance = maxDistance;

            // Agar filter natijasi bo'sh bo'lmasa, yangi markerlarni chizamiz
            if (_filteredClinics.isNotEmpty) {
              _mapController.createMapObjects(
                  _filteredClinics, _onClinicSelected);
              _mapController.moveToClinicsBounds(_filteredClinics);
            } else if (_allClinics.isNotEmpty) {
              // Agar filter natijasi bo'sh bo'lsa, barcha markerlarni qayta chizamiz
              _mapController.createMapObjects(_allClinics, _onClinicSelected);
              _mapController.moveToClinicsBounds(_allClinics);
            }
          });
        },
      ),
    );
  }

  // Masofa bo'yicha filtrlash metodi
  List<Clinic> _filterClinicsByDistance(
      List<Clinic> clinics, double maxDistanceKm) {
    if (_mapController.currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Joylashuvingiz aniqlanmadi'),
          duration: Duration(seconds: 2),
        ),
      );
      return clinics;
    }

    final List<Clinic> filtered = [];

    for (var clinic in clinics) {
      try {
        if (clinic.latitude.isEmpty || clinic.longitude.isEmpty) {
          continue;
        }

        final clinicLat = double.parse(clinic.latitude);
        final clinicLng = double.parse(clinic.longitude);

        final distanceInMeters = Geolocator.distanceBetween(
          _mapController.currentPosition!.latitude,
          _mapController.currentPosition!.longitude,
          clinicLat,
          clinicLng,
        );

        final distanceInKm = distanceInMeters / 1000;

        // Debug uchun masofani ko'rsatamiz
        debugPrint(
            'Klinika: ${clinic.nameUz}, Masofa: ${distanceInKm.toStringAsFixed(2)} km, Max: $maxDistanceKm km');

        if (distanceInKm <= maxDistanceKm) {
          filtered.add(clinic);
          debugPrint('✅ Filtrlangan klinikaga qo\'shildi: ${clinic.nameUz}');
        }
      } catch (e) {
        debugPrint('Klinika masofasini hisoblashda xatolik: $e');
      }
    }

    // Natijalarni log qilamiz
    debugPrint(
        'Filtrlangan klinikalar soni: ${filtered.length} / ${clinics.length}');

    // Agar hech qanday natija bo'lmasa, xabar ko'rsatish
    if (filtered.isEmpty && clinics.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${maxDistanceKm.toInt()} km masofada klinikalar topilmadi'),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ClinicsMapScreen building...');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Klinikalar xaritasi'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        actions: [
          // Filter icon with indicator when active
          Stack(
            children: [
              IconButton(
                onPressed: () => _showFilterDialog(),
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filtrlash',
              ),
              if (_mapController.maxDistance != 5.0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<ClinicBloc, ClinicState>(
            builder: (context, state) {
              debugPrint('BlocBuilder state: $state');

              if (state is ClinicLoaded) {
                debugPrint(
                    'ClinicLoaded: ${state.clinicsModel.clinics.length} klinikalar');

                // Klinikalarni saqlash
                if (_allClinics.isEmpty) {
                  _allClinics = state.clinicsModel.clinics;
                  _filteredClinics = [];

                  // Birinchi marta ekranga kirganda hamma klinikalarni ko'rsatish
                  if (_isFirstLoad) {
                    debugPrint('Birinchi marta yuklanish...');
                    _isFirstLoad = false;

                    // Lokatsiya aniqlangan bo'lsa, foydalanuvchi joylashuvini yangilash
                    if (_mapController.currentPosition != null) {
                      _mapController.updateUserLocationOnMap();
                    }

                    // Hamma klinikalarni ko'rsatish
                    _mapController.createMapObjects(
                        _allClinics, _onClinicSelected);
                  }
                }

                // Ko'rsatiladigan klinikalar (filtrlangan yoki barcha)
                final displayClinics = _filteredClinics.isNotEmpty
                    ? _filteredClinics
                    : _allClinics;

                return MapView(
                  clinics: displayClinics,
                  mapController: _mapController,
                  onClinicTap: _onClinicSelected,
                  onShowSearchDialog: () => _showSearchDialog(displayClinics),
                );
              } else if (state is ClinicLoading || _mapController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClinicError) {
                return ErrorView(
                  onRetry: () {
                    context.read<ClinicBloc>().add(const GetClinicsEvent());
                  },
                );
              }

              if (state is! ClinicLoading) {
                debugPrint('Loading holatida emas, ma\'lumot so\'ralmoqda...');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<ClinicBloc>().add(const GetClinicsEvent());
                });
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
      bottomSheet: (_selectedClinic != null)
          ? ClinicInfoBottomSheet(
              clinic: _selectedClinic!,
              currentPosition: _mapController.currentPosition,
              onClose: _closeClinicInfo,
              onNavigateToDetails: () =>
                  _navigateToClinicDetails(_selectedClinic!),
              onShowDirections: () {
                _mapController.openMapForDirections(context, _selectedClinic!);
              },
            )
          : null,
      // Filtrlash badge
      floatingActionButton: _mapController.maxDistance != 5.0
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _mapController.maxDistance = 5.0;
                  _filteredClinics = [];
                  _mapController.createMapObjects(
                      _allClinics, _onClinicSelected);
                  _mapController.moveToClinicsBounds(_allClinics);
                });
              },
              label: const Text('Filtrni o\'chirish'),
              icon: const Icon(Icons.clear),
              backgroundColor: Colors.redAccent,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
