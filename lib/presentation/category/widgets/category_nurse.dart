import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/request/pages/select_service_screen.dart';
import 'package:tez_med_client/presentation/request/widgets/animated_price.dart';

class CategoryNurse extends StatefulWidget {
  final List<Department> departments;
  const CategoryNurse({super.key, required this.departments});

  @override
  State<CategoryNurse> createState() => _CategoryNurseState();
}

class _CategoryNurseState extends State<CategoryNurse>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ValueNotifier<int> _selectedIndex;
  final List<Map<int, int>> _selectedServicesPerDepartment = [];

  @override
  void initState() {
    super.initState();
    // Initialize TabController safely
    _tabController = widget.departments.isNotEmpty
        ? TabController(length: widget.departments.length, vsync: this)
        : TabController(length: 0, vsync: this);

    _selectedIndex = ValueNotifier<int>(0);

    // Initialize selected services for each department
    for (var _ in widget.departments) {
      _selectedServicesPerDepartment.add({});
    }

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _selectedIndex.value = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;

    for (int departmentIndex = 0;
        departmentIndex < widget.departments.length;
        departmentIndex++) {
      final currentDepartment = widget.departments[departmentIndex];
      final allActiveServices = currentDepartment.affairs
          .expand((affair) => affair.service)
          .where((s) => s.isActive)
          .toList();

      final selectedServicesInDepartment =
          _selectedServicesPerDepartment[departmentIndex];

      for (var serviceEntry in selectedServicesInDepartment.entries) {
        final service = allActiveServices[serviceEntry.key];
        totalPrice += service.price * serviceEntry.value;
      }
    }

    return totalPrice;
  }

  void _updateSelectedServices(
      int departmentIndex, int serviceIndex, int quantity) {
    setState(() {
      if (quantity == 0) {
        _selectedServicesPerDepartment[departmentIndex].remove(serviceIndex);
      } else {
        _selectedServicesPerDepartment[departmentIndex][serviceIndex] =
            quantity;
      }
    });
  }

  List<RequestAffairGet> _buildRequestAffairList() {
    final List<RequestAffairGet> requestAffairs = [];
    final now = DateTime.now().toString();

    for (int departmentIndex = 0;
        departmentIndex < widget.departments.length;
        departmentIndex++) {
      final department = widget.departments[departmentIndex];
      final selectedServices = _selectedServicesPerDepartment[departmentIndex];

      final allActiveServices = department.affairs
          .expand((affair) => affair.service)
          .where((s) => s.isActive)
          .toList();

      for (var serviceEntry in selectedServices.entries) {
        final service = allActiveServices[serviceEntry.key];

        requestAffairs.add(RequestAffairGet(
            startDate: "",
            hour: "",
            nameUz: service.nameUz,
            nameEn: service.nameEn,
            nameRu: service.nameRu,
            price: service.price,
            affairId: service.id,
            count: serviceEntry.value,
            createdAt: now,
            typeModel: service.type));
      }
    }

    return requestAffairs;
  }

  bool _hasValidServices(int departmentIndex) {
    return _selectedServicesPerDepartment[departmentIndex].isNotEmpty;
  }

  void _navigateToUserDetails() {
    final currentIndex = _selectedIndex.value;
    if (!_hasValidServices(currentIndex)) return;

    final requestAffairs = _buildRequestAffairList();
    context.router.push(UserDetails(requestAffair: requestAffairs));
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageBloc>().state.locale.languageCode;

    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Column(
        children: [
          _buildTabBar(context, lang),
          Expanded(child: _buildTabBarView(lang)),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, String lang) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, _) {
          return TabBar(
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            controller: _tabController,
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 5),
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            labelColor: Colors.transparent,
            tabs: List.generate(
              widget.departments.length,
              (index) => _buildTab(
                  widget.departments[index], index, selectedIndex, lang),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(
      Department department, int index, int selectedIndex, String lang) {
    final isSelected = index == selectedIndex;
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : AppColor.buttonBackColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          lang == 'uz'
              ? department.nameUz
              : lang == 'en'
                  ? department.nameEn
                  : department.nameRu,
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

  Widget _buildTabBarView(String lang) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: widget.departments.asMap().entries.map((entry) {
        final departmentIndex = entry.key;
        final department = entry.value;

        final allActiveServices = department.affairs
            .expand((affair) => affair.service)
            .where((service) => service.isActive)
            .toList();

        return SelectServiceScreen(
          service: allActiveServices,
          selectedItems: _selectedServicesPerDepartment[departmentIndex],
          onUpdate: (serviceIndex, quantity) =>
              _updateSelectedServices(departmentIndex, serviceIndex, quantity),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigationBar() {
    final totalPrice = _calculateTotalPrice();
    return Container(
      height: 80,
      color: Colors.white,
      child: InkWell(
        onTap: totalPrice != 0 ? _navigateToUserDetails : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: totalPrice != 0
                  ? AppColor.primaryColor
                  : AppColor.greyTextColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).Continue,
                    style: AppTextstyle.nunitoBold.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  AnimatedPriceWidget(
                    initialPrice: 0,
                    targetPrice: totalPrice,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
