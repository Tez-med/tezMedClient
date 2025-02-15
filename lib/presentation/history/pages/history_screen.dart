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
    final tabs = [S.of(context).nurse, S.of(context).doctor];

    return AutoTabsRouter(
      routes: const [ActiveRequestRoute(), ActiveDoctorRequest()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          backgroundColor: AppColor.buttonBackColor,
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shadowColor: AppColor.buttonBackColor,
            elevation: 1,
            centerTitle: true,
            title: Text(
              S.of(context).current_order,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 22),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Row(
                children: [
                  _buildTabBar(tabs, tabsRouter),
                ],
              ),
            ),
          ),
          body: child,
        );
      },
    );
  }

  Widget _buildTabBar(List<String> tabs, TabsRouter tabsRouter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => InkWell(
            onTap: () => tabsRouter.setActiveIndex(index),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: tabsRouter.activeIndex == index
                    ? AppColor.primaryColor
                    : AppColor.buttonBackColor,
              ),
              child: Text(
                tabs[index],
                style: AppTextstyle.nunitoBold.copyWith(
                  fontSize: 15,
                  color: tabsRouter.activeIndex == index
                      ? Colors.white
                      : AppColor.greyColor500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
