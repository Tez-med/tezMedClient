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

class _CategoryNurseMainState extends State<CategoryNurseMain>
    with TickerProviderStateMixin {
  final List<Map<int, Map<int, int>>> _allSelectedServices = [];
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Tab o'zgarganda jonli yangilanish uchun Map
  final Map<int, int> _tabServicesCount = {};
  final Map<int, double> _tabPrices = {};
  final Map<int, String> _tabNames = {};

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Har bir kategoriya uchun bo'sh service map yaratish
    for (var _ in widget.category) {
      _allSelectedServices.add({});
    }

    _tabController = TabController(
        length: widget.category.length,
        vsync: this,
        initialIndex: _currentTabIndex);

    _tabController.addListener(_handleTabChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Context ga bog'liq metodlarni shu yerga yozamiz
    if (!_isInitialized) {
      _updateTabNames();
      _updateTabInfo();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  // Tab nomlarini yangilash
  void _updateTabNames() {
    for (int i = 0; i < widget.category.length; i++) {
      final category = widget.category[i];
      _tabNames[i] = context.toLocalized(
          uz: category.nameUz, ru: category.nameRu, en: category.nameEn);
    }
  }

  // Tab o'zgarganda yangilanish
  void _handleTabChange() {
    if (_tabController.indexIsChanging ||
        _tabController.index != _currentTabIndex) {
      setState(() {
        _currentTabIndex = _tabController.index;
        // Tab o'zgarganda nomlarni yangilash
        _updateTabNames();
      });
    }
  }

  // Barcha tablar ma'lumotlarini yangilash
  void _updateTabInfo() {
    for (int i = 0; i < widget.category.length; i++) {
      _tabServicesCount[i] = _getSelectedServicesCount(i);
      _tabPrices[i] = _calculateCategoryPrice(i);
    }
  }

  // Umumiy narxni hisoblash
  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (int categoryIndex = 0;
        categoryIndex < widget.category.length;
        categoryIndex++) {
      totalPrice += _calculateCategoryPrice(categoryIndex);
    }
    return totalPrice;
  }

  // Bitta kategoriya narxini hisoblash
  double _calculateCategoryPrice(int categoryIndex) {
    if (categoryIndex >= widget.category.length) return 0.0;

    double categoryPrice = 0.0;
    final category = widget.category[categoryIndex];
    final selectedServices = _allSelectedServices[categoryIndex];

    for (int departmentIndex = 0;
        departmentIndex < category.departments.length;
        departmentIndex++) {
      final department = category.departments[departmentIndex];
      final departmentServices = selectedServices[departmentIndex] ?? {};

      // Har bir bo'lim uchun barcha aktiv xizmatlarni yig'ish
      final allActiveServices = department.affairs
          .expand((affair) => affair.service)
          .where((s) => s.isActive)
          .toList();

      // Tanlangan xizmatlar uchun narxni qo'shish
      for (var serviceEntry in departmentServices.entries) {
        if (serviceEntry.key < allActiveServices.length) {
          final service = allActiveServices[serviceEntry.key];
          categoryPrice += service.price * serviceEntry.value;
        }
      }
    }

    return categoryPrice;
  }

  // Bir kategoriya uchun tanlangan xizmatlar sonini hisoblash
  int _getSelectedServicesCount(int categoryIndex) {
    if (categoryIndex >= _allSelectedServices.length) return 0;

    int count = 0;
    final selectedServices = _allSelectedServices[categoryIndex];

    selectedServices.forEach((departmentIndex, services) {
      services.forEach((serviceIndex, quantity) {
        count += quantity;
      });
    });

    return count;
  }

  // Joriy tab uchun tanlangan xizmatlar soni
  int _getCurrentTabServicesCount() {
    return _tabServicesCount[_currentTabIndex] ?? 0;
  }

  // Joriy kategoriya nomini olish

  // Xizmatlar ro'yxatini yangilash
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

      // Tab ma'lumotlarini yangilash
      _updateTabInfo();
    });
  }

  // So'rov uchun ma'lumotlar yig'ish
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
          if (serviceEntry.key < allActiveServices.length) {
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
    }
    return requestAffairs;
  }

  // Keyingi ekranga o'tish
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
    _updateTabNames();

    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        // TabBar qismini AppBar ni flexibleSpace sifatida emas, bottom sifatida beramiz
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: _buildTabBar(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          widget.category.length,
          (categoryIndex) => CategoryNurse(
            key: ValueKey('category_nurse_$categoryIndex'),
            departments: widget.category[categoryIndex].departments,
            selectedServices: _allSelectedServices[categoryIndex],
            onUpdateServices: (departmentIndex, serviceIndex, quantity) =>
                _updateSelectedServices(
                    categoryIndex, departmentIndex, serviceIndex, quantity),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 45,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.buttonBackColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 5),
            labelColor: Colors.black,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
                // Tab tanlaganda nomlarni yangilash
                _updateTabNames();
              });
            },
            unselectedLabelColor: AppColor.greyColor500,
            unselectedLabelStyle: AppTextstyle.nunitoMedium,
            labelStyle: AppTextstyle.nunitoBold.copyWith(fontSize: 14),
            tabs: List.generate(widget.category.length, (index) {
              final servicesCount = _tabServicesCount[index] ?? 0;
              final tabName = _tabNames[index] ?? "";
              return Tab(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tabName,
                            style: AppTextstyle.nunitoBold.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      if (servicesCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            servicesCount.toString(),
                            style: AppTextstyle.nunitoBold.copyWith(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final totalPrice = _calculateTotalPrice();
    _getCurrentTabServicesCount();

    return Container(
      height: 80,
      color: Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
