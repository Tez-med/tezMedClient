import 'package:flutter/material.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/presentation/category/widgets/category_nurse.dart';
import 'package:tez_med_client/presentation/request/widgets/animated_price.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/generated/l10n.dart';

@RoutePage()
class CategoryNurseMain extends StatefulWidget {
  final List<CategoryModel> category;
  final RequestModel requestModel;
  const CategoryNurseMain(
      {super.key, required this.category, required this.requestModel});

  @override
  State<CategoryNurseMain> createState() => _CategoryNurseMainState();
}

class _CategoryNurseMainState extends State<CategoryNurseMain> {
  final List<Map<int, Map<int, int>>> _allSelectedServices = [];

  @override
  void initState() {
    super.initState();
    for (var _ in widget.category) {
      _allSelectedServices.add({});
    }
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;

    for (int categoryIndex = 0;
        categoryIndex < widget.category.length;
        categoryIndex++) {
      final category = widget.category[categoryIndex];

      for (int departmentIndex = 0;
          departmentIndex < category.departments.length;
          departmentIndex++) {
        final department = category.departments[departmentIndex];
        final selectedServices =
            _allSelectedServices[categoryIndex][departmentIndex] ?? {};

        final allActiveServices = department.affairs
            .expand((affair) => affair.service)
            .where((s) => s.isActive)
            .toList();

        for (var serviceEntry in selectedServices.entries) {
          final service = allActiveServices[serviceEntry.key];
          totalPrice += service.price * serviceEntry.value;
        }
      }
    }
    return totalPrice;
  }

  void _updateSelectedServices(
      int categoryIndex, int departmentIndex, int serviceIndex, int quantity) {
    setState(() {
      if (!_allSelectedServices[categoryIndex].containsKey(departmentIndex)) {
        _allSelectedServices[categoryIndex][departmentIndex] = {};
      }

      if (quantity == 0) {
        _allSelectedServices[categoryIndex][departmentIndex]
            ?.remove(serviceIndex);
        if (_allSelectedServices[categoryIndex][departmentIndex]?.isEmpty ??
            false) {
          _allSelectedServices[categoryIndex].remove(departmentIndex);
        }
      } else {
        _allSelectedServices[categoryIndex][departmentIndex]?[serviceIndex] =
            quantity;
      }
    });
  }

  List<RequestAffairGet> _buildRequestAffairList() {
    final List<RequestAffairGet> requestAffairs = [];
    final now = DateTime.now().toString();

    for (int categoryIndex = 0;
        categoryIndex < widget.category.length;
        categoryIndex++) {
      final category = widget.category[categoryIndex];

      for (int departmentIndex = 0;
          departmentIndex < category.departments.length;
          departmentIndex++) {
        final department = category.departments[departmentIndex];
        final selectedServices =
            _allSelectedServices[categoryIndex][departmentIndex] ?? {};

        final allActiveServices = department.affairs
            .expand((affair) => affair.service)
            .where((s) => s.isActive)
            .toList();

        for (var serviceEntry in selectedServices.entries) {
          final service = allActiveServices[serviceEntry.key];
          requestAffairs.add(
            RequestAffairGet(
              startDate: "",
              hour: "",
              nameUz: service.nameUz,
              nameEn: service.nameEn,
              nameRu: service.nameRu,
              price: service.price,
              affairId: service.id,
              count: serviceEntry.value,
              createdAt: now,
              typeModel: service.type,
            ),
          );
        }
      }
    }
    return requestAffairs;
  }

  void _navigateToUserDetails() {
    final totalPrice = _calculateTotalPrice();
    if (totalPrice == 0) return;

    final requestAffairs = _buildRequestAffairList();

    final updatedRequestAffairsPost = requestAffairs.map((affairGet) {
      return RequestAffairPost(
        price: affairGet.price,
        nameEn: affairGet.nameEn,
        nameRu: affairGet.nameRu,
        nameUz: affairGet.nameUz,
        regionAffairId: widget.category.first.departments.first.affairs.first
            .service.first.regionAffairId,
        affairId: affairGet.affairId,
        count: affairGet.count,
        day: 1,
        startDate: affairGet.startDate,
      );
    }).toList();
    context.router.push(UserDetails(
        requestModel: widget.requestModel
            .copyWith(requestAffairs: updatedRequestAffairsPost)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.category.length,
      child: Scaffold(
        backgroundColor: AppColor.buttonBackColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: SizedBox(),
          flexibleSpace: _buildTabBar(widget.category
              .map((e) =>
                  context.toLocalized(uz: e.nameUz, ru: e.nameRu, en: e.nameEn))
              .toList()),
        ),
        body: TabBarView(
          children: List.generate(
            widget.category.length,
            (categoryIndex) => CategoryNurse(
              departments: widget.category[categoryIndex].departments,
              selectedServices: _allSelectedServices[categoryIndex],
              onUpdateServices: (departmentIndex, serviceIndex, quantity) =>
                  _updateSelectedServices(
                      categoryIndex, departmentIndex, serviceIndex, quantity),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildTabBar(List<String> tabs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColor.buttonBackColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 5),
          labelColor: Colors.black,
          unselectedLabelColor: AppColor.greyColor500,
          unselectedLabelStyle: AppTextstyle.nunitoMedium,
          labelStyle: AppTextstyle.nunitoBold.copyWith(fontSize: 14),
          tabs: tabs.map((String name) {
            return Tab(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name,
                    style: AppTextstyle.nunitoBold.copyWith(fontSize: 15),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
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
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 18, top: 10),
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
