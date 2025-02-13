import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

import '../../../core/bloc/language/language_bloc.dart';

class SelectServiceScreen extends StatefulWidget {
  final List<Service> service;
  final Map<int, int> selectedItems;
  final Function(int, int) onUpdate;

  const SelectServiceScreen({
    super.key,
    required this.service,
    required this.selectedItems,
    required this.onUpdate,
  });

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  final formatter = NumberFormat('#,###');

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: AppColor.greyColor500,
            size: 24,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageBloc>().state.locale.languageCode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: AppColor.buttonBackColor,
            );
          },
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: widget.service.where((service) => service.isActive).length,
          itemBuilder: (context, index) {
            final filtrGeneral = widget.service
                .where(
                  (service) => service.isActive,
                )
                .toList();
            final data = filtrGeneral[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 1),
              title: Text(
                lang == 'uz'
                    ? data.nameUz
                    : lang == 'en'
                        ? data.nameEn
                        : data.nameRu,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  height: 18 / 13,
                  letterSpacing: 0.01,
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
              subtitle: Text(
                "${formatter.format(data.price)} ${S.of(context).sum}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  height: 18 / 14,
                  letterSpacing: 0.01,
                  textBaseline: TextBaseline.alphabetic,
                  color: AppColor.primaryColor,
                ),
              ),
              trailing: widget.selectedItems.containsKey(index)
                  ? _buildQuantityControl(index)
                  : _buildAddButton(index),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuantityControl(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.buttonBackColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconButton(
            Icons.remove,
            () {
              setState(() {
                setState(() {});
                final currentQuantity = widget.selectedItems[index] ?? 0;
                if (currentQuantity > 0) {
                  widget.onUpdate(index, currentQuantity - 1);
                }
              });
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '${widget.selectedItems[index] ?? 0}',
              key: ValueKey<int>(widget.selectedItems[index] ?? 0),
              style: AppTextstyle.nunitoBold.copyWith(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          _buildIconButton(
            Icons.add,
            () {
              setState(() {});
              final currentQuantity = widget.selectedItems[index] ?? 0;
              widget.onUpdate(index, currentQuantity + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {});
        widget.onUpdate(index, 1);
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        side: const BorderSide(color: Colors.transparent),
        backgroundColor: AppColor.buttonBackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        S.of(context).add,
        style: AppTextstyle.nunitoRegular.copyWith(color: Colors.black),
      ),
    );
  }
}
