import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/data/banner/source/get_banner_source.dart';
import 'package:tez_med_client/data/species/source/get_nurse_type_source.dart';
import 'package:tez_med_client/domain/comments/usecase/post_comment_usecase.dart';
import 'package:tez_med_client/domain/doctor/useacase/doctor_usecase.dart';
import 'package:tez_med_client/domain/my_address/usecase/get_my_address_usecase.dart';
import 'package:tez_med_client/domain/notification/repositories/notification_repository.dart';
import 'package:tez_med_client/domain/profile_update/usecase/profile_update_usecase.dart';
import 'package:tez_med_client/domain/promocode/usecase/promocode_usecase.dart';
import 'package:tez_med_client/domain/region/usecase/get_region_usecase.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_active_request_usecase.dart';
import 'package:tez_med_client/domain/add_client/usecase/add_client_usecase.dart';
import 'package:tez_med_client/domain/auth/usecase/send_otp_usecase.dart';
import 'package:tez_med_client/domain/auth/usecase/verify_otp_usecase.dart';
import 'package:tez_med_client/domain/category/usecase/get_category_usecase.dart';
import 'package:tez_med_client/domain/profile/usecase/get_client_usecase.dart';
import 'package:tez_med_client/domain/request_post/usecase/post_request_usecase.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_by_id_request_usecase.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_finished_request_usecase.dart';
import 'package:tez_med_client/domain/species/usecase/get_species_usecase.dart';
import 'package:tez_med_client/injection.dart';
import 'package:tez_med_client/presentation/add_user/bloc/add_client/add_client_bloc.dart';
import 'package:tez_med_client/presentation/auth/bloc/send_otp/send_otp_bloc.dart';
import 'package:tez_med_client/presentation/auth/bloc/verify_user/verify_otp_bloc.dart';
import 'package:tez_med_client/presentation/banner/bloc/banner_bloc.dart';
import 'package:tez_med_client/presentation/category/bloc/nurse_type/nurse_type_bloc.dart';
import 'package:tez_med_client/presentation/category/bloc/species_get_bloc/species_get_by_id_bloc.dart';
import 'package:tez_med_client/presentation/doctor/bloc/doctor_details/doctor_details_bloc.dart';
import 'package:tez_med_client/presentation/doctor/bloc/doctor_get_list/doctor_bloc.dart';
import 'package:tez_med_client/presentation/doctor_request/bloc/doctor_request_bloc.dart';
import 'package:tez_med_client/presentation/history/bloc/active_request_bloc/active_request_bloc.dart';
import 'package:tez_med_client/presentation/history/bloc/finished_request_bloc/finished_bloc.dart';
import 'package:tez_med_client/presentation/history/bloc/get_by_id_request/get_by_id_request_bloc.dart';
import 'package:tez_med_client/presentation/home/bloc/category_bloc/category_bloc.dart';
import 'package:tez_med_client/presentation/home/bloc/species_bloc/species_bloc.dart';
import 'package:tez_med_client/presentation/notification/bloc/notification_bloc.dart';
import 'package:tez_med_client/presentation/order_details/bloc/comment_bloc.dart';
import 'package:tez_med_client/presentation/request/bloc/promocode/promocode_bloc.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_update/profile_update_bloc.dart';
import 'package:tez_med_client/presentation/request/bloc/my_address/my_address_bloc.dart';
import 'package:tez_med_client/presentation/request/bloc/request/request_bloc.dart';

import '../domain/upload_file/usecase/upload_file_usecase.dart';
import '../presentation/add_user/bloc/region/region_bloc.dart';
import '../presentation/request/bloc/file_upload/file_upload_bloc.dart';

class AppBlocProviders {
  static List get providers => [
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider(
          create: (context) =>
              SendOtpBloc(sendOtpUsecase: getIt<SendOtpUsecase>()),
        ),
        BlocProvider(
          create: (context) => VerifyOtpBloc(getIt<VerifyOtpUsecase>()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(getIt<GetCategoryUsecase>()),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => NotificationBloc(getIt<NotificationRepository>())
            ..add(InitializeNotifications()),
        ),
        BlocProvider(
          create: (context) => FileUploadBloc(getIt<UploadFileUsecase>()),
        ),
        BlocProvider(
          create: (context) => RequestBloc(getIt<PostRequestUsecase>()),
        ),
        BlocProvider(
          create: (context) => AddClientBloc(getIt<AddClientUsecase>()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(getIt<GetClientUsecase>()),
        ),
        BlocProvider(
          create: (context) =>
              ActiveRequestBloc(getIt<GetActiveRequestUsecase>()),
        ),
        BlocProvider(
          create: (context) => FinishedBloc(getIt<GetFinishedRequestUsecase>()),
        ),
        BlocProvider(
          create: (context) =>
              GetByIdRequestBloc(getIt<GetByIdRequestUsecase>()),
        ),
        BlocProvider(
            create: (context) => ProfileUpdateBloc(
                  getIt<ProfileUpdateUsecase>(),
                )),
        BlocProvider(
          create: (context) => MyAddressBloc(getIt<GetMyAddressUsecase>()),
        ),
        BlocProvider(
          create: (context) => RegionBloc(getIt<GetRegionUsecase>()),
        ),
        BlocProvider(
          create: (context) => PromocodeBloc(getIt<PromocodeUsecase>()),
        ),
        BlocProvider(
          create: (context) => CommentBloc(getIt<PostCommentUsecase>()),
        ),
        BlocProvider(
          create: (context) => SpeciesBloc(getIt<GetSpeciesUsecase>()),
        ),
        BlocProvider(
          create: (context) => SpeciesGetByIdBloc(getIt<GetSpeciesUsecase>()),
        ),
        BlocProvider(
          create: (context) =>
              NurseTypeBloc(getIt<GetNurseTypeSource>())..add(GetType()),
        ),
        BlocProvider(
          create: (context) => DoctorBloc(getIt<DoctorUsecase>()),
        ),
        BlocProvider(
          create: (context) => DoctorDetailsBloc(getIt<DoctorUsecase>()),
        ),
        BlocProvider(
          create: (context) =>
              BannerBloc(getIt<GetBannerSource>())..add(GetBanner()),
        ),
        BlocProvider(
          create: (context) => DoctorRequestBloc(getIt<DoctorUsecase>()),
        )
      ];
}
