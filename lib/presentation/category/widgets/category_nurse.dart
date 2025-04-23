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

class _CategoryNurseState extends State<CategoryNurse>
    with AutomaticKeepAliveClientMixin {
  // Avtomatik saqlash
  @override
  bool get wantKeepAlive => true;

  int _selectedIndex = 0;

  // Tanlangan bo'limning nomini saqlash

  @override
  void initState() {
    super.initState();
    _updateDepartmentName();
  }

  @override
  void didUpdateWidget(CategoryNurse oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget yangilanganda (masalan tab o'zgarganda),
    // nomi ham yangilanganiga ishonch hosil qilish
    _updateDepartmentName();
  }

  // Bo'lim nomini yangilash
  void _updateDepartmentName() {
    if (widget.departments.isNotEmpty &&
        _selectedIndex < widget.departments.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
        });
      });
    }
  }

  // Bo'lim nomini olish metodi

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final lang = context.read<LanguageBloc>().state.locale.languageCode;

    if (widget.departments.isEmpty) {
      return Center(
        child: Text("Bo'limlar mavjud emas"),
      );
    }

    // Indeks xatoliklari oldini olish
    if (_selectedIndex >= widget.departments.length) {
      _selectedIndex = widget.departments.length - 1;
      _updateDepartmentName();
    }

    return Column(
      children: [
        _buildDepartmentList(context, lang),
        Expanded(
          child: _buildServiceList(lang),
        ),
      ],
    );
  }

  Widget _buildDepartmentList(BuildContext context, String lang) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      height: 56.0,
      child: SingleChildScrollView(
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
                lang,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentItem(Department department, int index, String lang) {
    final isSelected = index == _selectedIndex;

    // Tanlangan xizmatlar sonini hisoblash
    final selectedItemsCount = (widget.selectedServices[index]?.values
            .fold<int>(0, (sum, count) => sum + count)) ??
        0;

    // Bo'lim nomi
    String name = context.toLocalized(
        uz: department.nameUz, ru: department.nameRu, en: department.nameEn);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : AppColor.buttonBackColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Text(
              name,
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
            if (selectedItemsCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  selectedItemsCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColor.primaryColor : Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(String lang) {
    if (_selectedIndex < 0 || _selectedIndex >= widget.departments.length) {
      return const Center(child: Text('Bo\'lim topilmadi'));
    }

    final department = widget.departments[_selectedIndex];

    final allActiveServices = department.affairs
        .expand((affair) => affair.service)
        .where((service) => service.isActive)
        .toList();

    if (allActiveServices.isEmpty) {
      return Center(
        child: Text('Xizmatlar mavjud emas'),
      );
    }

    return SelectServiceScreen(
      key: ValueKey('services_for_department_$_selectedIndex'),
      service: allActiveServices,
      selectedItems: widget.selectedServices[_selectedIndex] ?? {},
      onUpdate: (serviceIndex, quantity) =>
          widget.onUpdateServices(_selectedIndex, serviceIndex, quantity),
    );
  }
}
