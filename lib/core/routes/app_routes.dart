import 'package:auto_route/auto_route.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/presentation/category/screen/category_screen_doctor.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  static final AppRouter instance = AppRouter._();

  AppRouter._();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/', initial: true),
        AutoRoute(page: OnboardingRoute.page, path: '/onboarding'),
        AutoRoute(
          page: MainRoute.page,
          path: '/main_page',
          children: [
            AutoRoute(
              path: 'home',
              page: HomeRoute.page,
            ),
            AutoRoute(path: 'history', page: HistoryRoute.page, children: [
              AutoRoute(page: ActiveRequestRoute.page),
              AutoRoute(page: ActiveDoctorRequest.page),
            ]),
            AutoRoute(page: SupportRoute.page),
            AutoRoute(
              path: 'profile',
              page: ProfileRoute.page,
            ),
          ],
        ),
        AutoRoute(page: FinishedRequestRoute.page),
        AutoRoute(page: PhoneInputRoute.page, path: '/phone_input'),
        AutoRoute(page: SmsVerifyRoute.page, path: '/sms_verify'),
        AutoRoute(page: AddUserRoute.page, path: '/addUser'),
        // AutoRoute(page: SelectService.page, path: '/select_service'),
        AutoRoute(page: UserDetails.page, path: '/user_details'),
        AutoRoute(page: LocationDetails.page, path: '/location_details'),
        AutoRoute(page: YandexMapRoute.page, path: '/yandex_map'),
        AutoRoute(page: OrderDetailsRoute.page, path: '/order_details'),
        AutoRoute(page: ProfileUpdateRoute.page, path: '/profile_update'),
        AutoRoute(page: NotificationRoute.page, path: '/notification_page'),
        AutoRoute(page: SettingsRoute.page, path: '/settings'),
        AutoRoute(page: PrivacyPolicy.page, path: '/pirvacy'),
        AutoRoute(page: LanguageSelectRoute.page),
        AutoRoute(page: ClientData.page),
        AutoRoute(page: VideoCallRoute.page),
        AutoRoute(page: ServiceInfo.page),
        AutoRoute(page: CategoryNurseMain.page),
        AutoRoute(page: CategoryRouteDoctor.page),
        AutoRoute(page: CategoryRouteNurse.page),
      ];
}
