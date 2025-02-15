import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/active_doctor_bloc/active_doctor_request_bloc.dart';
import 'package:tez_med_client/presentation/history/bloc/active_request_bloc/active_request_bloc.dart';

@RoutePage()
class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width * 0.07;

    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        HistoryRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return PopScope(
          canPop: tabsRouter.activeIndex == 0,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            tabsRouter.setActiveIndex(0);
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: Platform.isIOS
                  ? [
                      BoxShadow(
                        color: AppColor.buttonBackColor.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -1),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: AppColor.buttonBackColor.withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Platform.isIOS
                ? CupertinoTabBar(
                    backgroundColor: Colors.white,
                    items: [
                      _buildBottomNavItem(
                        context,
                        index: 0,
                        svgAsset: Assets.icons.home,
                        label: S.of(context).home,
                        isSelected: tabsRouter.activeIndex == 0,
                        iconSize: iconSize,
                      ),
                      _buildBottomNavItem(
                        context,
                        index: 1,
                        svgAsset: Assets.icons.history,
                        label: S.of(context).order,
                        isSelected: tabsRouter.activeIndex == 1,
                        iconSize: iconSize,
                      ),
                      _buildBottomNavItem(
                        context,
                        index: 2,
                        svgAsset: Assets.icons.profile,
                        label: S.of(context).profile,
                        isSelected: tabsRouter.activeIndex == 2,
                        iconSize: iconSize,
                      ),
                    ],
                    onTap: (index) => _handleTabSelection(tabsRouter, index),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavItem(
                        count: false,
                        index: 0,
                        svgAsset: Assets.icons.home,
                        label: S.of(context).home,
                        isSelected: tabsRouter.activeIndex == 0,
                        iconSize: iconSize,
                        onTap: () => _handleTabSelection(tabsRouter, 0),
                      ),
                      _NavItem(
                        count: true,
                        index: 1,
                        svgAsset: Assets.icons.history,
                        label: S.of(context).current_order,
                        isSelected: tabsRouter.activeIndex == 1,
                        iconSize: iconSize,
                        onTap: () => _handleTabSelection(tabsRouter, 1),
                      ),
                      _NavItem(
                        count: false,
                        index: 2,
                        svgAsset: Assets.icons.profile,
                        label: S.of(context).profile,
                        isSelected: tabsRouter.activeIndex == 2,
                        iconSize: iconSize,
                        onTap: () => _handleTabSelection(tabsRouter, 2),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    BuildContext context, {
    required int index,
    required SvgGenImage svgAsset,
    required String label,
    required bool isSelected,
    required double iconSize,
  }) {
    final color = isSelected ? AppColor.primaryColor : Colors.black;
    final fontSize = MediaQuery.of(context).size.width * 0.035;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Expanded(
            child: svgAsset.svg(
              width: iconSize,
              height: iconSize,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          Text(
            label,
            style: AppTextstyle.nunitoBold.copyWith(
              color: color,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Expanded(
            child: svgAsset.svg(
              width: iconSize,
              height: iconSize,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          Text(
            label,
            style: AppTextstyle.nunitoBold.copyWith(
              color: color,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTabSelection(TabsRouter tabsRouter, int index) {
    if (tabsRouter.activeIndex != index) {
      tabsRouter.setActiveIndex(index);
    }
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final SvgGenImage svgAsset;
  final String label;
  final bool isSelected;
  final double iconSize;
  final VoidCallback onTap;
  final bool count;

  const _NavItem({
    required this.index,
    required this.svgAsset,
    required this.label,
    required this.isSelected,
    required this.iconSize,
    required this.onTap,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColor.primaryColor : Colors.black;
    final fontSize = MediaQuery.of(context).size.width * 0.035;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<ActiveRequestState>(
              stream: context.read<ActiveRequestBloc>().stream,
              builder: (context, snapshot) {
                int requestCount = 0;
                if (snapshot.hasData && snapshot.data is ActiveRequestLoaded) {
                  requestCount = (snapshot.data as ActiveRequestLoaded)
                      .requestss
                      .where(
                        (element) =>
                            element.status == "new" ||
                            element.status == "not_online" ||
                            element.status == "connecting" ||
                            element.status == "nurse_canceled" ||
                            element.status == "approved",
                      )
                      .length;
                }

                return BlocBuilder<ActiveDoctorRequestBloc,
                    ActiveDoctorRequestState>(
                  builder: (context, doctorState) {
                    int totalDoctorRequests = 0;
                    if (doctorState is ActiveDoctorRequestLoaded) {
                      totalDoctorRequests =
                          doctorState.scheduleModel.schedules.length;
                    }
                    int totalRequests = requestCount + totalDoctorRequests;

                    return count
                        ? Badge(
                            alignment: Alignment.topRight,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.all(4),
                            largeSize: 16,
                            smallSize: 12,
                            offset: const Offset(8, -8),
                            isLabelVisible: totalRequests > 0,
                            label: Text('$totalRequests'),
                            child: svgAsset.svg(
                              width: iconSize,
                              height: iconSize,
                              fit: BoxFit.cover,
                              colorFilter:
                                  ColorFilter.mode(color, BlendMode.srcIn),
                            ),
                          )
                        : svgAsset.svg(
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.cover,
                            colorFilter:
                                ColorFilter.mode(color, BlendMode.srcIn),
                          );
                  },
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextstyle.nunitoBold.copyWith(
                color: color,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
