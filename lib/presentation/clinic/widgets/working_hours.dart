import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

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

  // O'zbek tilidagi kun nomlari
  static const Map<int, String> _dayNamesUz = {
    1: 'Dushanba',
    2: 'Seshanba',
    3: 'Chorshanba',
    4: 'Payshanba',
    5: 'Juma',
    6: 'Shanba',
    7: 'Yakshanba',
  };

  // Ingliz tilidagi kun nomlari
  static const Map<int, String> _dayNamesEn = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday',
  };

  // Rus tilidagi kun nomlari
  static const Map<int, String> _dayNamesRu = {
    1: 'Понедельник',
    2: 'Вторник',
    3: 'Среда',
    4: 'Четверг',
    5: 'Пятница',
    6: 'Суббота',
    7: 'Воскресенье',
  };

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
    // Joriy tilni aniqlash
    final String currentLocale = Localizations.localeOf(context).toString();

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
                      Text(
                        _getEmptyHoursText(currentLocale),
                        style: const TextStyle(fontSize: 14),
                      ),

                    // Dastlab ko'rsatiladigan soatlar (maximum 3 ta)
                    if (sortedEntries.isNotEmpty)
                      ...sortedEntries
                          .take(_showAllHours
                              ? sortedEntries.length
                              : _initialVisibleCount)
                          .map((entry) => _buildHourItem(
                              entry.key, entry.value, currentLocale)),
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
                            _showAllHours
                                ? S.of(context).see_all
                                : _getSeeAllText(currentLocale),
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

  Widget _buildHourItem(int dayOfWeek, Hour hour, String locale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '${_getDayName(dayOfWeek, locale)}: ${hour.openHour} ${_getFromText(locale)} ${hour.closeHours} ${_getToText(locale)}',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  // Kunning nomini qaytaradi tilga moslab
  String _getDayName(int dayOfWeek, String locale) {
    final Map<int, String> dayNames;

    // Til kodiga qarab mos kunlar ro'yxatini tanlash
    if (locale.startsWith('en')) {
      dayNames = _dayNamesEn;
    } else if (locale.startsWith('ru')) {
      dayNames = _dayNamesRu;
    } else {
      dayNames = _dayNamesUz; // Default o'zbek tili
    }

    return dayNames[dayOfWeek] ?? 'Kun $dayOfWeek';
  }

  // "dan" so'zini tilga moslab qaytaradi
  String _getFromText(String locale) {
    if (locale.startsWith('en')) {
      return 'from';
    } else if (locale.startsWith('ru')) {
      return 'с';
    } else {
      return 'dan';
    }
  }

  // "gacha" so'zini tilga moslab qaytaradi
  String _getToText(String locale) {
    if (locale.startsWith('en')) {
      return 'to';
    } else if (locale.startsWith('ru')) {
      return 'до';
    } else {
      return 'gacha';
    }
  }

  // "Barchasini ko'rish" matnini tilga moslab qaytaradi
  String _getSeeAllText(String locale) {
    if (locale.startsWith('en')) {
      return 'See all';
    } else if (locale.startsWith('ru')) {
      return 'Показать все';
    } else {
      return 'Barchasini ko\'rish';
    }
  }

  // Bo'sh soatlar matnini tilga moslab qaytaradi
  String _getEmptyHoursText(String locale) {
    if (locale.startsWith('en')) {
      return 'Working hours not specified';
    } else if (locale.startsWith('ru')) {
      return 'Рабочее время не указано';
    } else {
      return 'Ish vaqti ko\'rsatilmagan';
    }
  }
}
