import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/presentation/request/pages/select_service_screen.dart';

class CategoryNurse extends StatefulWidget {
  final List<Department> departments;
  final Map<int, Map<int, int>> selectedServices;
  final Function(int, int, int) onUpdateServices;

  const CategoryNurse({
    super.key,
    required this.departments,
    required this.selectedServices,
    required this.onUpdateServices,
  });

  @override
  State<CategoryNurse> createState() => _CategoryNurseState();
}

class _CategoryNurseState extends State<CategoryNurse> {
  late ValueNotifier<int> _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageBloc>().state.locale.languageCode;

    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
        leading: SizedBox(),
        flexibleSpace: _buildDepartmentList(context, lang),
      ),
      body: _buildServiceList(lang),
    );
  }

  Widget _buildDepartmentList(BuildContext context, String lang) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: List.generate(
                widget.departments.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _buildDepartmentItem(
                    widget.departments[index],
                    index,
                    selectedIndex,
                    lang,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDepartmentItem(
      Department department, int index, int selectedIndex, String lang) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => _selectedIndex.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : AppColor.buttonBackColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          context.toLocalized(
              uz: department.nameUz,
              ru: department.nameRu,
              en: department.nameEn),
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 21 / 14,
            letterSpacing: 0.01,
            textBaseline: TextBaseline.alphabetic,
            color: isSelected ? Colors.white : Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildServiceList(String lang) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, selectedIndex, _) {
        final department = widget.departments[selectedIndex];
        final allActiveServices = department.affairs
            .expand((affair) => affair.service)
            .where((service) => service.isActive)
            .toList();

        return SelectServiceScreen(
          service: allActiveServices,
          selectedItems: widget.selectedServices[selectedIndex] ?? {},
          onUpdate: (serviceIndex, quantity) =>
              widget.onUpdateServices(selectedIndex, serviceIndex, quantity),
        );
      },
    );
  }
}
