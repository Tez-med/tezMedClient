// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:tez_med_client/core/routes/app_routes.gr.dart';
// import 'package:tez_med_client/core/utils/app_color.dart';
// import 'package:tez_med_client/core/utils/app_textstyle.dart';
// import 'package:tez_med_client/data/category/model/category_model.dart';
// import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
// import 'package:tez_med_client/generated/l10n.dart';
// import 'package:tez_med_client/presentation/request/pages/select_service_screen.dart';

// import 'package:tez_med_client/presentation/request/widgets/animated_price.dart';

// @RoutePage()
// class ServiceScreen extends StatefulWidget {
//   final List<Affairs> department;

//   const ServiceScreen({super.key, required this.department});

//   @override
//   State<ServiceScreen> createState() => _ServiceScreenState();
// }

// class _ServiceScreenState extends State<ServiceScreen>
//     with SingleTickerProviderStateMixin {
//   final Map<int, Map<int, int>> _selectedItems = {};

//   @override
//   void initState() {
//     super.initState();

//     for (int i = 0; i < widget.department.length; i++) {
//       _selectedItems[i] = {};
//     }
//   }

//   bool get _hasValidServices {
//     return _selectedItems.values.any((items) => items.isNotEmpty);
//   }

//   double _calculateTotalPrice() {
//     return _selectedItems.entries.fold(0.0, (sum, entry) {
//       final items = entry.value;
//       return sum +
//           items.entries.fold(0.0, (innerSum, item) {
//             final price = widget.department[entry.key].service[item.key].price;
//             return innerSum + price * item.value;
//           });
//     });
//   }

//   void _updateSelectedItems(int tabIndex, int serviceIndex, int quantity) {
//     setState(() {
//       if (quantity == 0) {
//         _selectedItems[tabIndex]!.remove(serviceIndex);
//       } else {
//         _selectedItems[tabIndex]![serviceIndex] = quantity;
//       }
//     });
//   }

//   List<RequestAffairGet> _buildRequestAffairList() {
//     final List<RequestAffairGet> affairs = [];
//     final now = DateTime.now().toString();

//     for (final entry in _selectedItems.entries) {
//       final department = widget.department[entry.key];
//       for (final item in entry.value.entries) {
//         final service = department.service[item.key];
//         affairs.add(RequestAffairGet(
//             startDate: "",
//             hour: "",
//             nameUz: service.nameUz,
//             nameEn: service.nameEn,
//             nameRu: service.nameRu,
//             price: service.price,
//             affairId: service.id,
//             count: item.value,
//             createdAt: now,
//             typeModel: TypeModel(
//                 id: service.type.id,
//                 nameUz: service.type.nameUz,
//                 nameEn: service.type.nameEn,
//                 nameRu: service.type.nameRu,
//                 price: service.type.price)));
//       }
//     }

//     return affairs;
//   }

//   void _navigateToUserDetails() {
//     if (!_hasValidServices) return;

//     final requestAffairs = _buildRequestAffairList();
//     context.router.push(UserDetails(requestAffair: requestAffairs));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.buttonBackColor,
//       body: ListView.builder(
//         shrinkWrap: true,
//         itemCount: widget.department.length,
//         itemBuilder: (context, index) {
//           final department = widget.department[index].service
//               .where(
//                 (element) => element.type.nameEn.toLowerCase() == "general",
//               )
//               .toList();
//           return SelectServiceScreen(
//             service: department,
//             selectedItems: _selectedItems[index]!,
//             onUpdate: (serviceIndex, quantity) =>
//                 _updateSelectedItems(index, serviceIndex, quantity),
//           );
//         },
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     final totalPrice = _calculateTotalPrice();
//     return Container(
//       height: 85,
//       padding: const EdgeInsets.all(16),
//       color: Colors.white,
//       child: InkWell(
//         onTap: _navigateToUserDetails,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   S.of(context).total_price,
//                   style: AppTextstyle.nunitoBold.copyWith(
//                     color: Colors.black,
//                     fontSize: 17,
//                   ),
//                 ),
//                 AnimatedPriceWidget(
//                   initialPrice: 0,
//                   targetPrice: totalPrice,
//                 ),
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               decoration: BoxDecoration(
//                 color: _hasValidServices
//                     ? AppColor.primaryColor
//                     : AppColor.buttonBackColor,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 S.of(context).Continue,
//                 style: AppTextstyle.nunitoBold.copyWith(
//                   color:
//                       _hasValidServices ? Colors.white : Colors.grey.shade600,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
