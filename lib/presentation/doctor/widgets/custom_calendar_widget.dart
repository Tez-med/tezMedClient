import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/doctor/model/basic_doctor_model.dart';

class CustomCalendarWidget extends StatefulWidget {
  final List<Schedule> data;
  final Function(String) onDateSelected;

  const CustomCalendarWidget(
      {super.key, required this.data, required this.onDateSelected});

  @override
  State<CustomCalendarWidget> createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late DateTime selectedDate;
  String? selectedTime;
  @override
  void initState() {
    super.initState();
    selectedDate = _getUniqueDates().first;
  }

  List<DateTime> _getUniqueDates() {
    return widget.data
        .map((schedule) => DateFormat('yyyy/MM/dd').parse(schedule.date))
        .toSet()
        .toList()
      ..sort();
  }

  List<String> _getAvailableTimes(DateTime date) {
    return widget.data
        .where(
            (schedule) => DateFormat('yyyy/MM/dd').parse(schedule.date) == date)
        .map((schedule) => schedule.time)
        .toList();
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedTime = null;
    });
  }

  void _selectTime(Schedule schedule) {
    setState(() {
      selectedTime = schedule.time;
    });
    widget.onDateSelected(schedule.id);
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> availableDates = _getUniqueDates();
    List<String> availableTimes = _getAvailableTimes(selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.MMMM('uz').format(selectedDate),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColor.textColor,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: AppColor.textColor),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColor.buttonBackColor,
                    shape: CircleBorder(),
                  ),
                  onPressed: () {
                    int currentIndex = availableDates.indexOf(selectedDate);
                    if (currentIndex > 0) {
                      _selectDate(availableDates[currentIndex - 1]);
                    }
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: AppColor.textColor),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColor.buttonBackColor,
                    shape: CircleBorder(),
                  ),
                  onPressed: () {
                    int currentIndex = availableDates.indexOf(selectedDate);
                    if (currentIndex < availableDates.length - 1) {
                      _selectDate(availableDates[currentIndex + 1]);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: availableDates.map((date) {
            bool isSelected = date == selectedDate;
            return Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(date),
                child: Column(
                  children: [
                    Text(
                      DateFormat.E('uz').format(date),
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
                      DateFormat('dd').format(date),
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
            );
          }).toList(),
        ),
        SizedBox(height: 15),
        Wrap(
          spacing: 5,
          runSpacing: 8,
          children: availableTimes.map((time) {
            final Schedule schedule = widget.data.firstWhere(
              (s) =>
                  s.time == time &&
                  s.date == DateFormat('yyyy/MM/dd').format(selectedDate),
            );

            bool isSelected = selectedTime == time;
            return GestureDetector(
              onTap: () {
                _selectTime(schedule);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.primaryColor
                      : AppColor.buttonBackColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.blue[700],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
