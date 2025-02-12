import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

@RoutePage()
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      S.of(context).current_order,
      S.of(context).history
    ];

    return AutoTabsRouter.tabBar(
      routes: const [
        ActiveRequestRoute(),
        FinishedRequestRoute(),
      ],
      builder: (context, child, controller) {
        return Scaffold(
          backgroundColor: AppColor.buttonBackColor,
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shadowColor: AppColor.buttonBackColor,
            elevation: 1,
            centerTitle: true,
            title: Text(
              S.of(context).order_history,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 22),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildTabBar(tabs, controller),
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar(List<String> tabs, TabController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          dividerColor: Colors.transparent,
          controller: controller,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 5),
          labelColor: Colors.black,
          unselectedLabelColor: AppColor.greyColor500,
          unselectedLabelStyle: AppTextstyle.nunitoRegular,
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
}
