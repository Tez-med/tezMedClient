import 'package:flutter/material.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

class ServicesSection extends StatefulWidget {
  final List<Amenity> services;
  final BuildContext context;

  const ServicesSection({
    super.key,
    required this.services,
    required this.context,
  });

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with SingleTickerProviderStateMixin {
  bool _showAllServices = false;
  late final AnimationController _animationController;
  late final Animation<double> _heightFactor;

  // Konstantalar
  static const int _initialVisibleCount = 2;

  @override
  void initState() {
    super.initState();

    // Animatsiya kontrollerini yaratish
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Animatsiya yaratish
    _heightFactor = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Xizmatlar ro'yxatini yaratish
  Map<String, Amenity> _getUniqueServices() {
    final Map<String, Amenity> uniqueServices = {};
    for (var service in widget.services) {
      final key = '${service.amenityId}_${service.nameUz}';
      if (!uniqueServices.containsKey(key)) {
        uniqueServices[key] = service;
      }
    }
    return uniqueServices;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueServices = _getUniqueServices();
    final servicesList = uniqueServices.values.toList();
    final hasMoreServices = servicesList.length > _initialVisibleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).services,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildServicesList(servicesList, hasMoreServices),
      ],
    );
  }

  Widget _buildServicesList(List<Amenity> servicesList, bool hasMoreServices) {
    if (servicesList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Xizmatlar mavjud emas'),
      );
    }

    // Dastlab ko'rsatiladigan xizmatlar
    final visibleServices = servicesList.take(_initialVisibleCount).toList();

    // Qolgan xizmatlar
    final remainingServices = hasMoreServices
        ? servicesList.sublist(_initialVisibleCount)
        : <Amenity>[];

    return Column(
      children: [
        // Dastlab ko'rinadigan xizmatlar
        ...visibleServices.map((service) => _buildServiceItem(service)),

        // Qolgan xizmatlar animatsiya bilan
        if (hasMoreServices)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  heightFactor: _showAllServices ? _heightFactor.value : 0,
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: Column(
              children: remainingServices
                  .map((service) => _buildServiceItem(service))
                  .toList(),
            ),
          ),

        if (hasMoreServices)
          GestureDetector(
            onTap: _toggleServicesVisibility,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _showAllServices ? "Yashirish" : "Barchasini ko'rish",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _showAllServices ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildServiceItem(Amenity service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (service.photo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CustomCachedImage(image: service.photo),
              ),
            ),
          Expanded(
            child: Text(
              widget.context.toLocalized(
                uz: service.nameUz,
                ru: service.nameRu,
                en: service.nameEn,
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleServicesVisibility() {
    setState(() {
      _showAllServices = !_showAllServices;
      if (_showAllServices) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
}
