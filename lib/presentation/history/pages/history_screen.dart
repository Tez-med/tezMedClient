import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/active_doctor_bloc/active_doctor_request_bloc.dart';
import 'package:tez_med_client/presentation/history/bloc/active_request_bloc/active_request_bloc.dart';

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

        final nurseOrdersCount = context.select((ActiveRequestBloc bloc) =>
            bloc.state is ActiveRequestLoaded
                ? (bloc.state as ActiveRequestLoaded).requestss.length
                : 0);

        final doctorOrdersCount = context.select(
            (ActiveDoctorRequestBloc bloc) =>
                bloc.state is ActiveDoctorRequestLoaded
                    ? (bloc.state as ActiveDoctorRequestLoaded)
                        .scheduleModel
                        .schedules
                        .length
                    : 0);

        // Tablar uchun count listini tayyorlash
        final tabCounts = [nurseOrdersCount, doctorOrdersCount];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context).current_order,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Row(
                children: [
                  _buildTabBar(tabs, tabsRouter, tabCounts),
                ],
              ),
            ),
          ),
          body: child,
        );
      },
    );
  }

  Widget _buildTabBar(
      List<String> tabs, TabsRouter tabsRouter, List<int> tabCounts) {
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
              child: Row(
                children: [
                  Text(
                    tabs[index],
                    style: AppTextstyle.nunitoBold.copyWith(
                      fontSize: 15,
                      color: tabsRouter.activeIndex == index
                          ? Colors.white
                          : AppColor.greyColor500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Zakazlar soni uchun badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: tabsRouter.activeIndex == index
                          ? Colors.white
                          : AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tabCounts[index].toString(),
                      style: AppTextstyle.nunitoBold.copyWith(
                        fontSize: 12,
                        color: tabsRouter.activeIndex == index
                            ? AppColor.primaryColor
                            : Colors.white,
                      ),
                    ),
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
