import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class DatePickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final bool onTap;

  const DatePickerWidget({
    this.onTap = false,
    required this.controller,
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.black.withValues(alpha: .6),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext builder) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xffDADADA),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    dateOrder: DatePickerDateOrder.ymd,
                    initialDateTime: selectedDate ?? DateTime.now(),
                    onDateTimeChanged: (newDate) {
                      onDateSelected(newDate);
                      controller.text =
                          DateFormat('yyyy-MM-dd').format(newDate);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xffDADADA),
                  ),
                  child: CupertinoButton(
                    child: Text(
                      S.of(context).choose,
                      style: AppTextstyle.nunitoBold
                          .copyWith(color: AppColor.primaryColor, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).birthday,
          style: AppTextstyle.nunitoExtraBold.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => onTap ? null : _showDatePicker(context),
          child: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColor.buttonBackColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.text.isEmpty ? 'yyyy-mm-dd' : controller.text,
                    style: AppTextstyle.nunitoBold.copyWith(
                      fontSize: 17,
                      color: controller.text.isEmpty
                          ? AppColor.greyTextColor
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
