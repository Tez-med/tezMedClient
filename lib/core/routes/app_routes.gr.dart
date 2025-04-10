// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i31;
import 'package:flutter/cupertino.dart' as _i35;
import 'package:flutter/material.dart' as _i32;
import 'package:tez_med_client/data/category/model/category_model.dart' as _i33;
import 'package:tez_med_client/data/profile/model/client_model.dart' as _i36;
import 'package:tez_med_client/data/request_post/model/request_model.dart'
    as _i34;
import 'package:tez_med_client/presentation/add_user/pages/add_user_screen.dart'
    as _i3;
import 'package:tez_med_client/presentation/auth/pages/phone_input_screen.dart'
    as _i19;
import 'package:tez_med_client/presentation/auth/pages/pirvacy_policy.dart'
    as _i20;
import 'package:tez_med_client/presentation/auth/pages/sms_verify_screen.dart'
    as _i25;
import 'package:tez_med_client/presentation/category/screen/category_screen_doctor.dart'
    as _i5;
import 'package:tez_med_client/presentation/category/screen/category_screen_nurse.dart'
    as _i6;
import 'package:tez_med_client/presentation/category/widgets/category_nurse_main.dart'
    as _i4;
import 'package:tez_med_client/presentation/disease/screen/disease_page.dart'
    as _i8;
import 'package:tez_med_client/presentation/doctor_request/screen/client_data.dart'
    as _i7;
import 'package:tez_med_client/presentation/history/pages/active_doctor_request.dart'
    as _i1;
import 'package:tez_med_client/presentation/history/pages/active_nurse_request.dart'
    as _i2;
import 'package:tez_med_client/presentation/history/pages/doctor_order_details_screen.dart'
    as _i9;
import 'package:tez_med_client/presentation/history/pages/finished_request_screen.dart'
    as _i10;
import 'package:tez_med_client/presentation/history/pages/history_screen.dart'
    as _i11;
import 'package:tez_med_client/presentation/order_details/pages/order_details_screen.dart'
    as _i18;
import 'package:tez_med_client/presentation/home/pages/home_screen.dart'
    as _i12;
import 'package:tez_med_client/presentation/main/pages/main_page.dart' as _i15;
import 'package:tez_med_client/presentation/notification/pages/notification_page.dart'
    as _i16;
import 'package:tez_med_client/presentation/profile/pages/profile_screen.dart'
    as _i21;
import 'package:tez_med_client/presentation/profile/pages/profile_update_screen.dart'
    as _i22;
import 'package:tez_med_client/presentation/profile/pages/settings_screen.dart'
    as _i24;
import 'package:tez_med_client/presentation/request/pages/location_details.dart'
    as _i14;
import 'package:tez_med_client/presentation/request/pages/service_info.dart'
    as _i23;
import 'package:tez_med_client/presentation/request/widgets/yandex_map_screen.dart'
    as _i30;
import 'package:tez_med_client/presentation/splash/language_select_screen.dart'
    as _i13;
import 'package:tez_med_client/presentation/splash/onboarding_screen.dart'
    as _i17;
import 'package:tez_med_client/presentation/splash/splash_screen.dart' as _i26;
import 'package:tez_med_client/presentation/support/pages/support_screen.dart'
    as _i27;
import 'package:tez_med_client/presentation/user_details_request/pages/user_details.dart'
    as _i28;
import 'package:tez_med_client/presentation/video_call/pages/video_call.dart'
    as _i29;

/// generated route for
/// [_i1.ActiveDoctorRequest]
class ActiveDoctorRequest extends _i31.PageRouteInfo<void> {
  const ActiveDoctorRequest({List<_i31.PageRouteInfo>? children})
      : super(
          ActiveDoctorRequest.name,
          initialChildren: children,
        );

  static const String name = 'ActiveDoctorRequest';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i1.ActiveDoctorRequest();
    },
  );
}

/// generated route for
/// [_i2.ActiveRequestScreen]
class ActiveRequestRoute extends _i31.PageRouteInfo<void> {
  const ActiveRequestRoute({List<_i31.PageRouteInfo>? children})
      : super(
          ActiveRequestRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActiveRequestRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i2.ActiveRequestScreen();
    },
  );
}

/// generated route for
/// [_i3.AddUserScreen]
class AddUserRoute extends _i31.PageRouteInfo<AddUserRouteArgs> {
  AddUserRoute({
    _i32.Key? key,
    required String phoneNumber,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          AddUserRoute.name,
          args: AddUserRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'AddUserRoute';

  static _i31.PageInfo page = _i31.PageInfo(
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

  final _i32.Key? key;

  final String phoneNumber;

  @override
  String toString() {
    return 'AddUserRouteArgs{key: $key, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [_i4.CategoryNurseMain]
class CategoryNurseMain extends _i31.PageRouteInfo<CategoryNurseMainArgs> {
  CategoryNurseMain({
    _i32.Key? key,
    required List<_i33.CategoryModel> category,
    required _i34.RequestModel requestModel,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          CategoryNurseMain.name,
          args: CategoryNurseMainArgs(
            key: key,
            category: category,
            requestModel: requestModel,
          ),
          initialChildren: children,
        );

  static const String name = 'CategoryNurseMain';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryNurseMainArgs>();
      return _i4.CategoryNurseMain(
        key: args.key,
        category: args.category,
        requestModel: args.requestModel,
      );
    },
  );
}

class CategoryNurseMainArgs {
  const CategoryNurseMainArgs({
    this.key,
    required this.category,
    required this.requestModel,
  });

  final _i32.Key? key;

  final List<_i33.CategoryModel> category;

  final _i34.RequestModel requestModel;

  @override
  String toString() {
    return 'CategoryNurseMainArgs{key: $key, category: $category, requestModel: $requestModel}';
  }
}

/// generated route for
/// [_i5.CategoryScreenDoctor]
class CategoryRouteDoctor extends _i31.PageRouteInfo<CategoryRouteDoctorArgs> {
  CategoryRouteDoctor({
    _i35.Key? key,
    required String title,
    required String id,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          CategoryRouteDoctor.name,
          args: CategoryRouteDoctorArgs(
            key: key,
            title: title,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CategoryRouteDoctor';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryRouteDoctorArgs>();
      return _i5.CategoryScreenDoctor(
        key: args.key,
        title: args.title,
        id: args.id,
      );
    },
  );
}

class CategoryRouteDoctorArgs {
  const CategoryRouteDoctorArgs({
    this.key,
    required this.title,
    required this.id,
  });

  final _i35.Key? key;

  final String title;

  final String id;

  @override
  String toString() {
    return 'CategoryRouteDoctorArgs{key: $key, title: $title, id: $id}';
  }
}

/// generated route for
/// [_i6.CategoryScreenNurse]
class CategoryRouteNurse extends _i31.PageRouteInfo<CategoryRouteNurseArgs> {
  CategoryRouteNurse({
    _i32.Key? key,
    required String title,
    required String id,
    required String district,
    required _i34.RequestModel requestModel,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          CategoryRouteNurse.name,
          args: CategoryRouteNurseArgs(
            key: key,
            title: title,
            id: id,
            district: district,
            requestModel: requestModel,
          ),
          initialChildren: children,
        );

  static const String name = 'CategoryRouteNurse';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryRouteNurseArgs>();
      return _i6.CategoryScreenNurse(
        key: args.key,
        title: args.title,
        id: args.id,
        district: args.district,
        requestModel: args.requestModel,
      );
    },
  );
}

class CategoryRouteNurseArgs {
  const CategoryRouteNurseArgs({
    this.key,
    required this.title,
    required this.id,
    required this.district,
    required this.requestModel,
  });

  final _i32.Key? key;

  final String title;

  final String id;

  final String district;

  final _i34.RequestModel requestModel;

  @override
  String toString() {
    return 'CategoryRouteNurseArgs{key: $key, title: $title, id: $id, district: $district, requestModel: $requestModel}';
  }
}

/// generated route for
/// [_i7.ClientData]
class ClientData extends _i31.PageRouteInfo<ClientDataArgs> {
  ClientData({
    _i35.Key? key,
    required String id,
    required bool online,
    required String type,
    required String price,
    List<_i31.PageRouteInfo>? children,
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

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClientDataArgs>();
      return _i7.ClientData(
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

  final _i35.Key? key;

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
/// [_i8.DiseasesScreen]
class DiseasesRoute extends _i31.PageRouteInfo<void> {
  const DiseasesRoute({List<_i31.PageRouteInfo>? children})
      : super(
          DiseasesRoute.name,
          initialChildren: children,
        );

  static const String name = 'DiseasesRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i8.DiseasesScreen();
    },
  );
}

/// generated route for
/// [_i9.DoctorOrderDetailsScreen]
class DoctorOrderDetailsRoute
    extends _i31.PageRouteInfo<DoctorOrderDetailsRouteArgs> {
  DoctorOrderDetailsRoute({
    _i35.Key? key,
    required String id,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          DoctorOrderDetailsRoute.name,
          args: DoctorOrderDetailsRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'DoctorOrderDetailsRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DoctorOrderDetailsRouteArgs>();
      return _i9.DoctorOrderDetailsScreen(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class DoctorOrderDetailsRouteArgs {
  const DoctorOrderDetailsRouteArgs({
    this.key,
    required this.id,
  });

  final _i35.Key? key;

  final String id;

  @override
  String toString() {
    return 'DoctorOrderDetailsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i10.FinishedRequestScreen]
class FinishedRequestRoute extends _i31.PageRouteInfo<void> {
  const FinishedRequestRoute({List<_i31.PageRouteInfo>? children})
      : super(
          FinishedRequestRoute.name,
          initialChildren: children,
        );

  static const String name = 'FinishedRequestRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i10.FinishedRequestScreen();
    },
  );
}

/// generated route for
/// [_i11.HistoryScreen]
class HistoryRoute extends _i31.PageRouteInfo<void> {
  const HistoryRoute({List<_i31.PageRouteInfo>? children})
      : super(
          HistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i11.HistoryScreen();
    },
  );
}

/// generated route for
/// [_i12.HomePage]
class HomeRoute extends _i31.PageRouteInfo<void> {
  const HomeRoute({List<_i31.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i12.HomePage();
    },
  );
}

/// generated route for
/// [_i13.LanguageSelectScreen]
class LanguageSelectRoute extends _i31.PageRouteInfo<void> {
  const LanguageSelectRoute({List<_i31.PageRouteInfo>? children})
      : super(
          LanguageSelectRoute.name,
          initialChildren: children,
        );

  static const String name = 'LanguageSelectRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i13.LanguageSelectScreen();
    },
  );
}

/// generated route for
/// [_i14.LocationDetails]
class LocationDetails extends _i31.PageRouteInfo<LocationDetailsArgs> {
  LocationDetails({
    _i32.Key? key,
    required String title,
    required String id,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          LocationDetails.name,
          args: LocationDetailsArgs(
            key: key,
            title: title,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'LocationDetails';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LocationDetailsArgs>();
      return _i14.LocationDetails(
        key: args.key,
        title: args.title,
        id: args.id,
      );
    },
  );
}

class LocationDetailsArgs {
  const LocationDetailsArgs({
    this.key,
    required this.title,
    required this.id,
  });

  final _i32.Key? key;

  final String title;

  final String id;

  @override
  String toString() {
    return 'LocationDetailsArgs{key: $key, title: $title, id: $id}';
  }
}

/// generated route for
/// [_i15.MainPage]
class MainRoute extends _i31.PageRouteInfo<void> {
  const MainRoute({List<_i31.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i15.MainPage();
    },
  );
}

/// generated route for
/// [_i16.NotificationPage]
class NotificationRoute extends _i31.PageRouteInfo<void> {
  const NotificationRoute({List<_i31.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i16.NotificationPage();
    },
  );
}

/// generated route for
/// [_i17.OnboardingScreen]
class OnboardingRoute extends _i31.PageRouteInfo<void> {
  const OnboardingRoute({List<_i31.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i17.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i18.OrderDetailsScreen]
class OrderDetailsRoute extends _i31.PageRouteInfo<OrderDetailsRouteArgs> {
  OrderDetailsRoute({
    _i32.Key? key,
    required String id,
    required String number,
    required String nursePhoto,
    List<_i31.PageRouteInfo>? children,
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

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailsRouteArgs>();
      return _i18.OrderDetailsScreen(
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

  final _i32.Key? key;

  final String id;

  final String number;

  final String nursePhoto;

  @override
  String toString() {
    return 'OrderDetailsRouteArgs{key: $key, id: $id, number: $number, nursePhoto: $nursePhoto}';
  }
}

/// generated route for
/// [_i19.PhoneInputScreen]
class PhoneInputRoute extends _i31.PageRouteInfo<void> {
  const PhoneInputRoute({List<_i31.PageRouteInfo>? children})
      : super(
          PhoneInputRoute.name,
          initialChildren: children,
        );

  static const String name = 'PhoneInputRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i19.PhoneInputScreen();
    },
  );
}

/// generated route for
/// [_i20.PrivacyPolicy]
class PrivacyPolicy extends _i31.PageRouteInfo<void> {
  const PrivacyPolicy({List<_i31.PageRouteInfo>? children})
      : super(
          PrivacyPolicy.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicy';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i20.PrivacyPolicy();
    },
  );
}

/// generated route for
/// [_i21.ProfileScreen]
class ProfileRoute extends _i31.PageRouteInfo<void> {
  const ProfileRoute({List<_i31.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i21.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i22.ProfileUpdateScreen]
class ProfileUpdateRoute extends _i31.PageRouteInfo<ProfileUpdateRouteArgs> {
  ProfileUpdateRoute({
    _i32.Key? key,
    required _i36.ClientModel clientModel,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          ProfileUpdateRoute.name,
          args: ProfileUpdateRouteArgs(
            key: key,
            clientModel: clientModel,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileUpdateRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileUpdateRouteArgs>();
      return _i22.ProfileUpdateScreen(
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

  final _i32.Key? key;

  final _i36.ClientModel clientModel;

  @override
  String toString() {
    return 'ProfileUpdateRouteArgs{key: $key, clientModel: $clientModel}';
  }
}

/// generated route for
/// [_i23.ServiceInfo]
class ServiceInfo extends _i31.PageRouteInfo<ServiceInfoArgs> {
  ServiceInfo({
    _i32.Key? key,
    required _i34.RequestModel requestModel,
    required int price,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          ServiceInfo.name,
          args: ServiceInfoArgs(
            key: key,
            requestModel: requestModel,
            price: price,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceInfo';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServiceInfoArgs>();
      return _i23.ServiceInfo(
        key: args.key,
        requestModel: args.requestModel,
        price: args.price,
      );
    },
  );
}

class ServiceInfoArgs {
  const ServiceInfoArgs({
    this.key,
    required this.requestModel,
    required this.price,
  });

  final _i32.Key? key;

  final _i34.RequestModel requestModel;

  final int price;

  @override
  String toString() {
    return 'ServiceInfoArgs{key: $key, requestModel: $requestModel, price: $price}';
  }
}

/// generated route for
/// [_i24.SettingsScreen]
class SettingsRoute extends _i31.PageRouteInfo<void> {
  const SettingsRoute({List<_i31.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i24.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i25.SmsVerifyScreen]
class SmsVerifyRoute extends _i31.PageRouteInfo<SmsVerifyRouteArgs> {
  SmsVerifyRoute({
    _i32.Key? key,
    required String phoneNumber,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          SmsVerifyRoute.name,
          args: SmsVerifyRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'SmsVerifyRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SmsVerifyRouteArgs>();
      return _i25.SmsVerifyScreen(
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

  final _i32.Key? key;

  final String phoneNumber;

  @override
  String toString() {
    return 'SmsVerifyRouteArgs{key: $key, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [_i26.SplashScreen]
class SplashRoute extends _i31.PageRouteInfo<void> {
  const SplashRoute({List<_i31.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i26.SplashScreen();
    },
  );
}

/// generated route for
/// [_i27.SupportScreen]
class SupportRoute extends _i31.PageRouteInfo<void> {
  const SupportRoute({List<_i31.PageRouteInfo>? children})
      : super(
          SupportRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupportRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i27.SupportScreen();
    },
  );
}

/// generated route for
/// [_i28.UserDetails]
class UserDetails extends _i31.PageRouteInfo<UserDetailsArgs> {
  UserDetails({
    _i32.Key? key,
    required _i34.RequestModel requestModel,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          UserDetails.name,
          args: UserDetailsArgs(
            key: key,
            requestModel: requestModel,
          ),
          initialChildren: children,
        );

  static const String name = 'UserDetails';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserDetailsArgs>();
      return _i28.UserDetails(
        key: args.key,
        requestModel: args.requestModel,
      );
    },
  );
}

class UserDetailsArgs {
  const UserDetailsArgs({
    this.key,
    required this.requestModel,
  });

  final _i32.Key? key;

  final _i34.RequestModel requestModel;

  @override
  String toString() {
    return 'UserDetailsArgs{key: $key, requestModel: $requestModel}';
  }
}

/// generated route for
/// [_i29.VideoCallScreen]
class VideoCallRoute extends _i31.PageRouteInfo<VideoCallRouteArgs> {
  VideoCallRoute({
    _i32.Key? key,
    required String url,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          VideoCallRoute.name,
          args: VideoCallRouteArgs(
            key: key,
            url: url,
          ),
          initialChildren: children,
        );

  static const String name = 'VideoCallRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VideoCallRouteArgs>();
      return _i29.VideoCallScreen(
        key: args.key,
        url: args.url,
      );
    },
  );
}

class VideoCallRouteArgs {
  const VideoCallRouteArgs({
    this.key,
    required this.url,
  });

  final _i32.Key? key;

  final String url;

  @override
  String toString() {
    return 'VideoCallRouteArgs{key: $key, url: $url}';
  }
}

/// generated route for
/// [_i30.YandexMapScreen]
class YandexMapRoute extends _i31.PageRouteInfo<void> {
  const YandexMapRoute({List<_i31.PageRouteInfo>? children})
      : super(
          YandexMapRoute.name,
          initialChildren: children,
        );

  static const String name = 'YandexMapRoute';

  static _i31.PageInfo page = _i31.PageInfo(
    name,
    builder: (data) {
      return const _i30.YandexMapScreen();
    },
  );
}
