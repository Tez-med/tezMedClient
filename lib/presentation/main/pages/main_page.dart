import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
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
        SupportRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return PopScope(
          canPop: tabsRouter.activeIndex == 0,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            tabsRouter.setActiveIndex(0);
          },
          child: Platform.isIOS
              ? _buildIOSNavBar(context, tabsRouter, iconSize)
              : _buildAndroidNavBar(context, tabsRouter, iconSize),
        );
      },
    );
  }

  Widget _buildIOSNavBar(
      BuildContext context, TabsRouter tabsRouter, double iconSize) {
    return CupertinoTabBar(
      backgroundColor: Colors.white,
      border: const Border(top: BorderSide(color: Colors.transparent)),
      activeColor: AppColor.primaryColor,
      inactiveColor: Colors.black,
      height: kBottomNavigationBarHeight + 15,
      iconSize: iconSize,
      items: [
        BottomNavigationBarItem(
          icon: Assets.icons.home.svg(
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(
              tabsRouter.activeIndex == 0
                  ? AppColor.primaryColor
                  : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          label: S.of(context).home,
        ),
        _buildNavBarItemWithBadge(
          context,
          tabsRouter,
          1,
          Assets.icons.history,
          S.of(context).order,
          iconSize,
        ),
        BottomNavigationBarItem(
          icon: Assets.icons.call.svg(
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(
              tabsRouter.activeIndex == 2
                  ? AppColor.primaryColor
                  : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          label: S.of(context).helpSupport,
        ),
        BottomNavigationBarItem(
          icon: Assets.icons.profile.svg(
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(
              tabsRouter.activeIndex == 3
                  ? AppColor.primaryColor
                  : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          label: S.of(context).profile,
        ),
      ],
      onTap: (index) => _handleTabSelection(tabsRouter, index),
    );
  }

  Widget _buildAndroidNavBar(
      BuildContext context, TabsRouter tabsRouter, double iconSize) {
    return NavigationBar(
      height: kBottomNavigationBarHeight + 15,
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      selectedIndex: tabsRouter.activeIndex,
      onDestinationSelected: (index) => _handleTabSelection(tabsRouter, index),
      destinations: [
        NavigationDestination(
          icon: Assets.icons.home.svg(
            width: iconSize,
            height: iconSize,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          selectedIcon: Assets.icons.home.svg(
            width: iconSize,
            height: iconSize,
            colorFilter:
                ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
          ),
          label: S.of(context).home,
        ),
        _buildNavigationDestinationWithBadge(
          context,
          tabsRouter,
          Assets.icons.history,
          S.of(context).current_order,
          iconSize,
        ),
        NavigationDestination(
          icon: Assets.icons.call.svg(
            width: iconSize,
            height: iconSize,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          selectedIcon: Assets.icons.call.svg(
            width: iconSize,
            height: iconSize,
            colorFilter:
                ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
          ),
          label: S.of(context).helpSupport,
        ),
        NavigationDestination(
          icon: Assets.icons.profile.svg(
            width: iconSize,
            height: iconSize,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          selectedIcon: Assets.icons.profile.svg(
            width: iconSize,
            height: iconSize,
            colorFilter:
                ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
          ),
          label: S.of(context).profile,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavBarItemWithBadge(
    BuildContext context,
    TabsRouter tabsRouter,
    int index,
    SvgGenImage svgAsset,
    String label,
    double iconSize,
  ) {
    return BottomNavigationBarItem(
      icon: _BadgeWrapper(
        isSelected: tabsRouter.activeIndex == index,
        svgAsset: svgAsset,
        iconSize: iconSize,
      ),
      label: label,
    );
  }

  NavigationDestination _buildNavigationDestinationWithBadge(
    BuildContext context,
    TabsRouter tabsRouter,
    SvgGenImage svgAsset,
    String label,
    double iconSize,
  ) {
    return NavigationDestination(
      icon: _BadgeWrapper(
        isSelected: false,
        svgAsset: svgAsset,
        iconSize: iconSize,
      ),
      selectedIcon: _BadgeWrapper(
        isSelected: true,
        svgAsset: svgAsset,
        iconSize: iconSize,
      ),
      label: label,
    );
  }

  void _handleTabSelection(TabsRouter tabsRouter, int index) {
    if (tabsRouter.activeIndex != index) {
      tabsRouter.setActiveIndex(index);
    }
  }
}

class _BadgeWrapper extends StatelessWidget {
  final bool isSelected;
  final SvgGenImage svgAsset;
  final double iconSize;

  const _BadgeWrapper({
    required this.isSelected,
    required this.svgAsset,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColor.primaryColor : Colors.black;

    return StreamBuilder<ActiveRequestState>(
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

        return BlocBuilder<ActiveDoctorRequestBloc, ActiveDoctorRequestState>(
          builder: (context, doctorState) {
            int totalDoctorRequests = 0;
            if (doctorState is ActiveDoctorRequestLoaded) {
              totalDoctorRequests = doctorState.scheduleModel.schedules.length;
            }
            int totalRequests = requestCount + totalDoctorRequests;

            return Badge(
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
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            );
          },
        );
      },
    );
  }
}
