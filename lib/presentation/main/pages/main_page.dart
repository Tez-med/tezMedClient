import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/active_doctor_bloc/active_doctor_request_bloc.dart';
import 'package:tez_med_client/presentation/history/bloc/active_request_bloc/active_request_bloc.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive icon sizing based on device type and screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isIpad = Platform.isIOS && screenWidth >= 768;

    // iPad uchun ko'proq moslashtirilgan hajm
    final double iconSize = isIpad
        ? screenWidth * 0.035 // iPad uchun kichikroq foiz
        : screenWidth * 0.07; // Telefonlar uchun original hajm

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
              ? _buildIOSNavBar(context, tabsRouter, iconSize, isIpad)
              : _buildAndroidNavBar(context, tabsRouter, iconSize),
        );
      },
    );
  }

  Widget _buildIOSNavBar(BuildContext context, TabsRouter tabsRouter,
      double iconSize, bool isIpad) {
    // iPad uchun balandlik
    final navBarHeight = isIpad
        ? kBottomNavigationBarHeight + 25 // iPad uchun yanada kattaroq
        : kBottomNavigationBarHeight + 15;

    // iPad uchun shrift hajmi
    final textStyle = isIpad
        ? const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500) // iPad uchun yaxshilangan shrift
        : null; // Telefonlar uchun standart hajm

    return CupertinoTabBar(
      backgroundColor: Colors.white,
      border: const Border(top: BorderSide(color: Colors.transparent)),
      height: navBarHeight,
      // iPad uchun iconSize ko'paytirildi
      iconSize: isIpad ? iconSize * 1.2 : iconSize,
      currentIndex: tabsRouter.activeIndex,
      activeColor: AppColor.primaryColor,
      inactiveColor: Colors.black,
      items: [
        _buildCupertinoItem(tabsRouter, 0, Assets.icons.home,
            S.of(context).home, iconSize, textStyle),
        _buildNavBarItemWithBadge(context, tabsRouter, 1, Assets.icons.history,
            S.of(context).order, iconSize, textStyle),
        _buildCupertinoItem(tabsRouter, 2, Assets.icons.call,
            S.of(context).helpSupport, iconSize, textStyle),
        _buildCupertinoItem(tabsRouter, 3, Assets.icons.profile,
            S.of(context).profile, iconSize, textStyle),
      ],
      onTap: (index) => _handleTabSelection(tabsRouter, index),
    );
  }

  BottomNavigationBarItem _buildCupertinoItem(
    TabsRouter tabsRouter,
    int index,
    SvgGenImage svgAsset,
    String label,
    double iconSize,
    TextStyle? textStyle,
  ) {
    final bool isSelected = tabsRouter.activeIndex == index;
    final color = isSelected ? AppColor.primaryColor : Colors.black;

    // iPad uchun to'liq moslashtirish, har doim active/inactive uchun
    if (textStyle != null) {
      return BottomNavigationBarItem(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            svgAsset.svg(
              width: iconSize * 1.2, // iPad uchun kattaroq hajm
              height: iconSize * 1.2,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: textStyle.copyWith(
                color: color,
                fontSize:
                    isSelected ? textStyle.fontSize : textStyle.fontSize! * 0.9,
              ),
            ),
          ],
        ),
        label: "", // Bo'sh qoldiring, tepada allaqachon label qo'shilgan
      );
    } else {
      // Telefon uchun standart item
      return BottomNavigationBarItem(
        icon: svgAsset.svg(
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        label: label,
      );
    }
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
    TextStyle? textStyle,
  ) {
    final bool isSelected = tabsRouter.activeIndex == index;
    final color = isSelected ? AppColor.primaryColor : Colors.black;

    // iPad uchun to'liq moslashtirish, har doim active/inactive uchun
    if (textStyle != null) {
      return BottomNavigationBarItem(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BadgeWrapper(
              isSelected: isSelected,
              svgAsset: svgAsset,
              iconSize: iconSize * 1.2, // iPad uchun kattaroq
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: textStyle.copyWith(
                color: color,
                fontSize:
                    isSelected ? textStyle.fontSize : textStyle.fontSize! * 0.9,
              ),
            ),
          ],
        ),
        label: "", // Bo'sh qoldiring, tepada allaqachon label qo'shilgan
      );
    } else {
      // Telefon uchun standart item
      return BottomNavigationBarItem(
        icon: _BadgeWrapper(
          isSelected: isSelected,
          svgAsset: svgAsset,
          iconSize: iconSize,
        ),
        label: label,
      );
    }
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
    // iPad uchun tekshirish
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isIpad = Platform.isIOS && screenWidth >= 768;

    // iPad uchun badge parametrlarini moslashtirish
    final badgeOffset = isIpad ? const Offset(12, -12) : const Offset(8, -8);
    final badgeLargeSize = isIpad ? 24.0 : 16.0;
    final badgeSmallSize = isIpad ? 20.0 : 12.0;
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: isIpad ? 12 : 10,
      fontWeight: FontWeight.bold,
    );

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
              totalDoctorRequests = doctorState.scheduleModel.schedules
                  .where((element) => element.status != "done")
                  .length;
            }
            int totalRequests = requestCount + totalDoctorRequests;

            return Badge(
              alignment: Alignment.topRight,
              textStyle: textStyle,
              padding: EdgeInsets.all(isIpad ? 6 : 4),
              largeSize: badgeLargeSize,
              smallSize: badgeSmallSize,
              offset: badgeOffset,
              isLabelVisible: totalRequests > 0,
              label: Text('$totalRequests'),
              child: svgAsset.svg(
                width: iconSize,
                height: iconSize,
                fit: BoxFit.cover,
                colorFilter: isSelected
                    ? ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn)
                    : ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            );
          },
        );
      },
    );
  }
}
