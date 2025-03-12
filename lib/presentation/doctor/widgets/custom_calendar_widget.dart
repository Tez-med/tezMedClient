import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/extension/date_format_extension.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/doctor/model/basic_doctor_model.dart';

class CustomCalendarWidget extends StatefulWidget {
  final List<Schedule> data;
  final Function(String) onDateSelected;

  const CustomCalendarWidget({
    super.key,
    required this.data,
    required this.onDateSelected,
  });

  @override
  State<CustomCalendarWidget> createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late final ValueNotifier<DateTime> selectedDateNotifier;

  late final ValueNotifier<String?> selectedTimeNotifier;
  String? selectedScheduleId;

  late final List<DateTime> availableDates;
  late final Map<DateTime, List<Schedule>> scheduleMap;

  @override
  void initState() {
    super.initState();

    final filteredSchedules =
        widget.data.where((s) => s.status == 'free').toList();

    scheduleMap = _createScheduleMap(filteredSchedules);

    availableDates = scheduleMap.keys.toList()..sort();

    final initialDate =
        availableDates.isNotEmpty ? availableDates.first : DateTime.now();

    selectedDateNotifier = ValueNotifier<DateTime>(initialDate);
    selectedTimeNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    selectedDateNotifier.dispose();
    selectedTimeNotifier.dispose();
    super.dispose();
  }

  Map<DateTime, List<Schedule>> _createScheduleMap(List<Schedule> schedules) {
    final Map<DateTime, List<Schedule>> result = {};

    final Set<DateTime> uniqueDates =
        schedules.map((s) => DateFormat('yyyy/MM/dd').parse(s.date)).toSet();

    for (final date in uniqueDates) {
      result[date] = schedules
          .where((s) => DateFormat('yyyy/MM/dd').parse(s.date) == date)
          .toList();
    }

    return result;
  }

  void _selectDate(DateTime date) {
    selectedDateNotifier.value = date;
  }

  void _selectTime(Schedule schedule) {
    selectedTimeNotifier.value = schedule.time;
    selectedScheduleId = schedule.id;

    widget.onDateSelected(schedule.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthSelector(),
        SizedBox(height: 15),
        _buildDateSelector(),
        SizedBox(height: 15),
        _buildTimeSelector(),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return ValueListenableBuilder<DateTime>(
        valueListenable: selectedDateNotifier,
        builder: (context, selectedDate, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.formatDate(date: selectedDate, pattern: 'MMMM'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textColor,
                ),
              ),
              Row(
                children: [
                  _buildArrowButton(Icons.chevron_left, -1),
                  SizedBox(width: 8),
                  _buildArrowButton(Icons.chevron_right, 1),
                ],
              ),
            ],
          );
        });
  }

  Widget _buildArrowButton(IconData icon, int direction) {
    return IconButton(
      icon: Icon(icon, color: AppColor.textColor),
      style: IconButton.styleFrom(
        backgroundColor: AppColor.buttonBackColor,
        shape: CircleBorder(),
      ),
      onPressed: () {
        int currentIndex = availableDates.indexOf(selectedDateNotifier.value);
        int newIndex = currentIndex + direction;
        if (newIndex >= 0 && newIndex < availableDates.length) {
          _selectDate(availableDates[newIndex]);
        }
      },
    );
  }

  Widget _buildDateSelector() {
    return ValueListenableBuilder<DateTime>(
        valueListenable: selectedDateNotifier,
        builder: (context, selectedDate, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: availableDates.map((date) {
              bool isSelected = date.isAtSameMomentAs(selectedDate);

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectDate(date),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Text(
                            context.formatDate(date: date, pattern: 'E'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColor.textColor
                                  : AppColor.greyTextColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            context.formatDate(date: date, pattern: 'dd'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColor.textColor
                                  : AppColor.greyTextColor,
                            ),
                          ),
                          SizedBox(height: 5),
                          Stack(
                            children: [
                              Container(
                                height: 2,
                                width: double.infinity,
                                color: AppColor.buttonBackColor,
                              ),
                              if (isSelected)
                                Container(
                                  height: 2,
                                  width: double.infinity,
                                  color: AppColor.primaryColor,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }

  Widget _buildTimeSelector() {
    return ValueListenableBuilder<DateTime>(
        valueListenable: selectedDateNotifier,
        builder: (context, selectedDate, _) {
          List<Schedule> schedulesForSelectedDate =
              scheduleMap[selectedDate] ?? [];

          return ValueListenableBuilder<String?>(
              valueListenable: selectedTimeNotifier,
              builder: (context, selectedTime, _) {
                return Wrap(
                  spacing: 5,
                  runSpacing: 8,
                  children: schedulesForSelectedDate.map((schedule) {
                    bool isSelected = selectedTime == schedule.time &&
                        selectedScheduleId == schedule.id;

                    return Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        onTap: () => _selectTime(schedule),
                        borderRadius: BorderRadius.circular(24),
                        child: Ink(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 17),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primaryColor
                                : AppColor.buttonBackColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            schedule.time,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color:
                                  isSelected ? Colors.white : Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              });
        });
  }
}
