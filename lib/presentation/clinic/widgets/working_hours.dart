import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';

class WorkingHoursWidget extends StatefulWidget {
  final List<Hour> hours;

  const WorkingHoursWidget({super.key, required this.hours});

  @override
  State<WorkingHoursWidget> createState() => _WorkingHoursWidgetState();
}

class _WorkingHoursWidgetState extends State<WorkingHoursWidget>
    with SingleTickerProviderStateMixin {
  bool _showAllHours = false;
  late final AnimationController _animationController;

  // Konstantalar
  static const int _initialVisibleCount = 3;

  @override
  void initState() {
    super.initState();

    // Animatsiya kontrollerini yaratish
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleHoursVisibility() {
    setState(() {
      _showAllHours = !_showAllHours;
      if (_showAllHours) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kunlar bo'yicha guruhlangan ish soatlari
    final Map<int, Hour> uniqueHours = {};

    // Har bir kun uchun eng so'nggi qo'shilgan ish soatini olamiz
    for (var hour in widget.hours) {
      if (!uniqueHours.containsKey(hour.dayOfWeek) ||
          uniqueHours[hour.dayOfWeek]!.createdAt.compareTo(hour.createdAt) <
              0) {
        uniqueHours[hour.dayOfWeek] = hour;
      }
    }

    // Kunlar tartib bo'yicha tartiblangan ro'yxat
    final sortedEntries = uniqueHours.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final hasMoreHours = sortedEntries.length > _initialVisibleCount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Agar hours bo'sh bo'lsa
                    if (sortedEntries.isEmpty)
                      const Text(
                        'Ish vaqti ko\'rsatilmagan',
                        style: TextStyle(fontSize: 14),
                      ),

                    // Dastlab ko'rsatiladigan soatlar (maximum 3 ta)
                    if (sortedEntries.isNotEmpty)
                      ...sortedEntries
                          .take(_showAllHours
                              ? sortedEntries.length
                              : _initialVisibleCount)
                          .map(
                              (entry) => _buildHourItem(entry.key, entry.value))
                          .toList(),
                  ],
                ),
              ),
            ],
          ),

          // "Ko'proq ko'rsatish" tugmasi
          if (hasMoreHours)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: _toggleHoursVisibility,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColor.primaryColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _showAllHours ? "Yashirish" : "Barchasini ko'rish",
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: _showAllHours ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColor.primaryColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHourItem(int dayOfWeek, Hour hour) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '${_getDayName(dayOfWeek)}: ${hour.openHour} dan ${hour.closeHours} gacha',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Dushanba';
      case 2:
        return 'Seshanba';
      case 3:
        return 'Chorshanba';
      case 4:
        return 'Payshanba';
      case 5:
        return 'Juma';
      case 6:
        return 'Shanba';
      case 7:
        return 'Yakshanba';
      default:
        return 'Kun $dayOfWeek';
    }
  }
}
