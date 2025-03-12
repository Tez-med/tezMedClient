import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class DeliveryTimeWidget extends StatefulWidget {
  final ValueChanged<DateTime> onTimeSelected;

  const DeliveryTimeWidget({
    super.key,
    required this.onTimeSelected,
  });

  @override
  State<DeliveryTimeWidget> createState() => _DeliveryTimeWidgetState();
}

class _DeliveryTimeWidgetState extends State<DeliveryTimeWidget> {
  DateTime selectedDateTime = DateTime.now().add(const Duration(minutes: 60));
  bool? isScheduledDelivery;
  final DateTime initialDateTime =
      DateTime.now().add(const Duration(minutes: 60));

  Future<void> _showDateTimePicker() async {
    DateTime tempDateTime = selectedDateTime;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Picker Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          pickerTextStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 20,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        height: 200,
                        child: CupertinoDatePicker(
                          initialDateTime: initialDateTime,
                          minimumDate: initialDateTime,
                          maximumDate: DateTime(
                            initialDateTime.year,
                            initialDateTime.month,
                            initialDateTime.day + 7,
                            0,
                            0,
                          ),
                          mode: CupertinoDatePickerMode.dateAndTime,
                          use24hFormat: true,
                          backgroundColor: Colors.white,
                          onDateTimeChanged: (DateTime newDateTime) {
                            tempDateTime = newDateTime;
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Button Card
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        setState(() {
                          selectedDateTime = tempDateTime;
                          widget.onTimeSelected(selectedDateTime);
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).choose,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).select_time,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  isScheduledDelivery = false;
                  selectedDateTime =
                      DateTime.now().add(const Duration(minutes: 60));
                  widget.onTimeSelected(selectedDateTime);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${S.of(context).current_time} ~ ${_formatTime(selectedDateTime)} (1 ${S.of(context).hour})',
                        style: AppTextstyle.nunitoMedium.copyWith(fontSize: 15),
                      ),
                    ),
                    Radio<bool?>(
                      value: false,
                      activeColor: AppColor.primaryColor,
                      groupValue: isScheduledDelivery,
                      onChanged: (value) {
                        setState(() {
                          isScheduledDelivery = false;
                          selectedDateTime =
                              DateTime.now().add(const Duration(minutes: 60));
                          widget.onTimeSelected(selectedDateTime);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                setState(() {
                  isScheduledDelivery = true;
                });
                await _showDateTimePicker();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).setting_according_table,
                          style:
                              AppTextstyle.nunitoMedium.copyWith(fontSize: 15),
                        ),
                        if (isScheduledDelivery == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${_formatDate(selectedDateTime)} ${_formatTime(selectedDateTime)}',
                            style: AppTextstyle.nunitoMedium.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Radio<bool?>(
                      value: true,
                      activeColor: AppColor.primaryColor,
                      groupValue: isScheduledDelivery,
                      onChanged: (value) async {
                        setState(() {
                          isScheduledDelivery = true;
                        });
                        await _showDateTimePicker();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Yanvar',
      'Fevral',
      'Mart',
      'Aprel',
      'May',
      'Iyun',
      'Iyul',
      'Avgust',
      'Sentabr',
      'Oktabr',
      'Noyabr',
      'Dekabr'
    ];
    return '${dateTime.day}-${months[dateTime.month - 1]}';
  }
}
