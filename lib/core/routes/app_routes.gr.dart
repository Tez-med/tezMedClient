// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i24;
import 'package:flutter/cupertino.dart' as _i26;
import 'package:flutter/material.dart' as _i25;
import 'package:tez_med_client/data/profile/model/client_model.dart' as _i28;
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart'
    as _i27;
import 'package:tez_med_client/presentation/add_user/pages/add_user_screen.dart'
    as _i3;
import 'package:tez_med_client/presentation/auth/pages/phone_input_screen.dart'
    as _i15;
import 'package:tez_med_client/presentation/auth/pages/pirvacy_policy.dart'
    as _i16;
import 'package:tez_med_client/presentation/auth/pages/sms_verify_screen.dart'
    as _i20;
import 'package:tez_med_client/presentation/category/screen/category_screen.dart'
    as _i4;
import 'package:tez_med_client/presentation/doctor_request/screen/client_data.dart'
    as _i5;
import 'package:tez_med_client/presentation/history/pages/active_doctor_request.dart'
    as _i1;
import 'package:tez_med_client/presentation/history/pages/active_nurse_request.dart'
    as _i2;
import 'package:tez_med_client/presentation/history/pages/finished_request_screen.dart'
    as _i6;
import 'package:tez_med_client/presentation/history/pages/history_screen.dart'
    as _i7;
import 'package:tez_med_client/presentation/home/pages/home_screen.dart' as _i8;
import 'package:tez_med_client/presentation/main/pages/main_page.dart' as _i11;
import 'package:tez_med_client/presentation/notification/pages/notification_page.dart'
    as _i12;
import 'package:tez_med_client/presentation/order_details/pages/order_details_screen.dart'
    as _i14;
import 'package:tez_med_client/presentation/profile/pages/profile_screen.dart'
    as _i17;
import 'package:tez_med_client/presentation/profile/pages/profile_update_screen.dart'
    as _i18;
import 'package:tez_med_client/presentation/profile/pages/settings_screen.dart'
    as _i19;
import 'package:tez_med_client/presentation/request/pages/location_details.dart'
    as _i10;
import 'package:tez_med_client/presentation/request/widgets/yandex_map_screen.dart'
    as _i23;
import 'package:tez_med_client/presentation/splash/language_select_screen.dart'
    as _i9;
import 'package:tez_med_client/presentation/splash/onboarding_screen.dart'
    as _i13;
import 'package:tez_med_client/presentation/splash/splash_screen.dart' as _i21;
import 'package:tez_med_client/presentation/user_details_request/pages/user_details.dart'
    as _i22;

/// generated route for
/// [_i1.ActiveDoctorRequest]
class ActiveDoctorRequest extends _i24.PageRouteInfo<void> {
  const ActiveDoctorRequest({List<_i24.PageRouteInfo>? children})
      : super(
          ActiveDoctorRequest.name,
          initialChildren: children,
        );

  static const String name = 'ActiveDoctorRequest';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i1.ActiveDoctorRequest();
    },
  );
}

/// generated route for
/// [_i2.ActiveRequestScreen]
class ActiveRequestRoute extends _i24.PageRouteInfo<void> {
  const ActiveRequestRoute({List<_i24.PageRouteInfo>? children})
      : super(
          ActiveRequestRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActiveRequestRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i2.ActiveRequestScreen();
    },
  );
}

/// generated route for
/// [_i3.AddUserScreen]
class AddUserRoute extends _i24.PageRouteInfo<AddUserRouteArgs> {
  AddUserRoute({
    _i25.Key? key,
    required String phoneNumber,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          AddUserRoute.name,
          args: AddUserRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'AddUserRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddUserRouteArgs>();
      return _i3.AddUserScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
      );
    },
  );
}

class AddUserRouteArgs {
  const AddUserRouteArgs({
    this.key,
    required this.phoneNumber,
  });

  final _i25.Key? key;

  final String phoneNumber;

  @override
  String toString() {
    return 'AddUserRouteArgs{key: $key, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [_i4.CategoryScreen]
class CategoryRoute extends _i24.PageRouteInfo<CategoryRouteArgs> {
  CategoryRoute({
    _i26.Key? key,
    required String title,
    required String id,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          CategoryRoute.name,
          args: CategoryRouteArgs(
            key: key,
            title: title,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CategoryRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryRouteArgs>();
      return _i4.CategoryScreen(
        key: args.key,
        title: args.title,
        id: args.id,
      );
    },
  );
}

class CategoryRouteArgs {
  const CategoryRouteArgs({
    this.key,
    required this.title,
    required this.id,
  });

  final _i26.Key? key;

  final String title;

  final String id;

  @override
  String toString() {
    return 'CategoryRouteArgs{key: $key, title: $title, id: $id}';
  }
}

/// generated route for
/// [_i5.ClientData]
class ClientData extends _i24.PageRouteInfo<ClientDataArgs> {
  ClientData({
    _i26.Key? key,
    required String id,
    required bool online,
    required String type,
    required String price,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          ClientData.name,
          args: ClientDataArgs(
            key: key,
            id: id,
            online: online,
            type: type,
            price: price,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientData';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClientDataArgs>();
      return _i5.ClientData(
        key: args.key,
        id: args.id,
        online: args.online,
        type: args.type,
        price: args.price,
      );
    },
  );
}

class ClientDataArgs {
  const ClientDataArgs({
    this.key,
    required this.id,
    required this.online,
    required this.type,
    required this.price,
  });

  final _i26.Key? key;

  final String id;

  final bool online;

  final String type;

  final String price;

  @override
  String toString() {
    return 'ClientDataArgs{key: $key, id: $id, online: $online, type: $type, price: $price}';
  }
}

/// generated route for
/// [_i6.FinishedRequestScreen]
class FinishedRequestRoute extends _i24.PageRouteInfo<void> {
  const FinishedRequestRoute({List<_i24.PageRouteInfo>? children})
      : super(
          FinishedRequestRoute.name,
          initialChildren: children,
        );

  static const String name = 'FinishedRequestRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i6.FinishedRequestScreen();
    },
  );
}

/// generated route for
/// [_i7.HistoryScreen]
class HistoryRoute extends _i24.PageRouteInfo<void> {
  const HistoryRoute({List<_i24.PageRouteInfo>? children})
      : super(
          HistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i7.HistoryScreen();
    },
  );
}

/// generated route for
/// [_i8.HomePage]
class HomeRoute extends _i24.PageRouteInfo<void> {
  const HomeRoute({List<_i24.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i8.HomePage();
    },
  );
}

/// generated route for
/// [_i9.LanguageSelectScreen]
class LanguageSelectRoute extends _i24.PageRouteInfo<void> {
  const LanguageSelectRoute({List<_i24.PageRouteInfo>? children})
      : super(
          LanguageSelectRoute.name,
          initialChildren: children,
        );

  static const String name = 'LanguageSelectRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i9.LanguageSelectScreen();
    },
  );
}

/// generated route for
/// [_i10.LocationDetails]
class LocationDetails extends _i24.PageRouteInfo<LocationDetailsArgs> {
  LocationDetails({
    _i25.Key? key,
    required List<_i27.RequestAffairGet> requestAffair,
    required List<String> photo,
    required String extraPhone,
    required int price,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          LocationDetails.name,
          args: LocationDetailsArgs(
            key: key,
            requestAffair: requestAffair,
            photo: photo,
            extraPhone: extraPhone,
            price: price,
          ),
          initialChildren: children,
        );

  static const String name = 'LocationDetails';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LocationDetailsArgs>();
      return _i10.LocationDetails(
        key: args.key,
        requestAffair: args.requestAffair,
        photo: args.photo,
        extraPhone: args.extraPhone,
        price: args.price,
      );
    },
  );
}

class LocationDetailsArgs {
  const LocationDetailsArgs({
    this.key,
    required this.requestAffair,
    required this.photo,
    required this.extraPhone,
    required this.price,
  });

  final _i25.Key? key;

  final List<_i27.RequestAffairGet> requestAffair;

  final List<String> photo;

  final String extraPhone;

  final int price;

  @override
  String toString() {
    return 'LocationDetailsArgs{key: $key, requestAffair: $requestAffair, photo: $photo, extraPhone: $extraPhone, price: $price}';
  }
}

/// generated route for
/// [_i11.MainPage]
class MainRoute extends _i24.PageRouteInfo<void> {
  const MainRoute({List<_i24.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i11.MainPage();
    },
  );
}

/// generated route for
/// [_i12.NotificationPage]
class NotificationRoute extends _i24.PageRouteInfo<void> {
  const NotificationRoute({List<_i24.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i12.NotificationPage();
    },
  );
}

/// generated route for
/// [_i13.OnboardingScreen]
class OnboardingRoute extends _i24.PageRouteInfo<void> {
  const OnboardingRoute({List<_i24.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i13.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i14.OrderDetailsScreen]
class OrderDetailsRoute extends _i24.PageRouteInfo<OrderDetailsRouteArgs> {
  OrderDetailsRoute({
    _i25.Key? key,
    required String id,
    required String number,
    required String nursePhoto,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          OrderDetailsRoute.name,
          args: OrderDetailsRouteArgs(
            key: key,
            id: id,
            number: number,
            nursePhoto: nursePhoto,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderDetailsRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailsRouteArgs>();
      return _i14.OrderDetailsScreen(
        key: args.key,
        id: args.id,
        number: args.number,
        nursePhoto: args.nursePhoto,
      );
    },
  );
}

class OrderDetailsRouteArgs {
  const OrderDetailsRouteArgs({
    this.key,
    required this.id,
    required this.number,
    required this.nursePhoto,
  });

  final _i25.Key? key;

  final String id;

  final String number;

  final String nursePhoto;

  @override
  String toString() {
    return 'OrderDetailsRouteArgs{key: $key, id: $id, number: $number, nursePhoto: $nursePhoto}';
  }
}

/// generated route for
/// [_i15.PhoneInputScreen]
class PhoneInputRoute extends _i24.PageRouteInfo<void> {
  const PhoneInputRoute({List<_i24.PageRouteInfo>? children})
      : super(
          PhoneInputRoute.name,
          initialChildren: children,
        );

  static const String name = 'PhoneInputRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i15.PhoneInputScreen();
    },
  );
}

/// generated route for
/// [_i16.PrivacyPolicy]
class PrivacyPolicy extends _i24.PageRouteInfo<void> {
  const PrivacyPolicy({List<_i24.PageRouteInfo>? children})
      : super(
          PrivacyPolicy.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicy';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i16.PrivacyPolicy();
    },
  );
}

/// generated route for
/// [_i17.ProfileScreen]
class ProfileRoute extends _i24.PageRouteInfo<void> {
  const ProfileRoute({List<_i24.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i17.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i18.ProfileUpdateScreen]
class ProfileUpdateRoute extends _i24.PageRouteInfo<ProfileUpdateRouteArgs> {
  ProfileUpdateRoute({
    _i25.Key? key,
    required _i28.ClientModel clientModel,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          ProfileUpdateRoute.name,
          args: ProfileUpdateRouteArgs(
            key: key,
            clientModel: clientModel,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileUpdateRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileUpdateRouteArgs>();
      return _i18.ProfileUpdateScreen(
        key: args.key,
        clientModel: args.clientModel,
      );
    },
  );
}

class ProfileUpdateRouteArgs {
  const ProfileUpdateRouteArgs({
    this.key,
    required this.clientModel,
  });

  final _i25.Key? key;

  final _i28.ClientModel clientModel;

  @override
  String toString() {
    return 'ProfileUpdateRouteArgs{key: $key, clientModel: $clientModel}';
  }
}

/// generated route for
/// [_i19.SettingsScreen]
class SettingsRoute extends _i24.PageRouteInfo<void> {
  const SettingsRoute({List<_i24.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i19.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i20.SmsVerifyScreen]
class SmsVerifyRoute extends _i24.PageRouteInfo<SmsVerifyRouteArgs> {
  SmsVerifyRoute({
    _i25.Key? key,
    required String phoneNumber,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          SmsVerifyRoute.name,
          args: SmsVerifyRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'SmsVerifyRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SmsVerifyRouteArgs>();
      return _i20.SmsVerifyScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
      );
    },
  );
}

class SmsVerifyRouteArgs {
  const SmsVerifyRouteArgs({
    this.key,
    required this.phoneNumber,
  });

  final _i25.Key? key;

  final String phoneNumber;

  @override
  String toString() {
    return 'SmsVerifyRouteArgs{key: $key, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [_i21.SplashScreen]
class SplashRoute extends _i24.PageRouteInfo<void> {
  const SplashRoute({List<_i24.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i21.SplashScreen();
    },
  );
}

/// generated route for
/// [_i22.UserDetails]
class UserDetails extends _i24.PageRouteInfo<UserDetailsArgs> {
  UserDetails({
    _i25.Key? key,
    required List<_i27.RequestAffairGet> requestAffair,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          UserDetails.name,
          args: UserDetailsArgs(
            key: key,
            requestAffair: requestAffair,
          ),
          initialChildren: children,
        );

  static const String name = 'UserDetails';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserDetailsArgs>();
      return _i22.UserDetails(
        key: args.key,
        requestAffair: args.requestAffair,
      );
    },
  );
}

class UserDetailsArgs {
  const UserDetailsArgs({
    this.key,
    required this.requestAffair,
  });

  final _i25.Key? key;

  final List<_i27.RequestAffairGet> requestAffair;

  @override
  String toString() {
    return 'UserDetailsArgs{key: $key, requestAffair: $requestAffair}';
  }
}

/// generated route for
/// [_i23.YandexMapScreen]
class YandexMapRoute extends _i24.PageRouteInfo<void> {
  const YandexMapRoute({List<_i24.PageRouteInfo>? children})
      : super(
          YandexMapRoute.name,
          initialChildren: children,
        );

  static const String name = 'YandexMapRoute';

  static _i24.PageInfo page = _i24.PageInfo(
    name,
    builder: (data) {
      return const _i23.YandexMapScreen();
    },
  );
}
