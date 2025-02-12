import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_med_client/data/banner/source/get_banner_source.dart';
import 'package:tez_med_client/data/comments/repositories/comment_repositories_impl.dart';
import 'package:tez_med_client/data/comments/source/comment_source.dart';
import 'package:tez_med_client/data/doctor/repositories/doctor_repositories_impl.dart';
import 'package:tez_med_client/data/doctor/source/doctor_source.dart';
import 'package:tez_med_client/data/my_address/repositories/my_address_repositories_impl.dart';
import 'package:tez_med_client/data/my_address/source/my_address_source.dart';
import 'package:tez_med_client/data/notification/repositories/notification_repository_impl.dart';
import 'package:tez_med_client/data/profile_update/repositories/profile_update_repositories_impl.dart';
import 'package:tez_med_client/data/profile_update/source/profile_update_source.dart';
import 'package:tez_med_client/data/promocode/repositories/promocode_repositories_impl.dart';
import 'package:tez_med_client/data/promocode/source/promocode_source.dart';
import 'package:tez_med_client/data/requests_get/repositories/active_request_repositories_impl.dart';
import 'package:tez_med_client/data/requests_get/repositories/finished_request_repositories_impl.dart';
import 'package:tez_med_client/data/requests_get/repositories/id_request_repositories_impl.dart';
import 'package:tez_med_client/data/requests_get/source/active_request_source.dart';
import 'package:tez_med_client/data/add_client/repositories/add_client_repositories_impl.dart';
import 'package:tez_med_client/data/add_client/source/add_client_source.dart';
import 'package:tez_med_client/data/auth/repositories/send_otp_repositories_impl.dart';
import 'package:tez_med_client/data/auth/repositories/verify_otp_repositories_impl.dart';
import 'package:tez_med_client/data/auth/source/send_otp_source.dart';
import 'package:tez_med_client/data/auth/source/verify_otp_source.dart';
import 'package:tez_med_client/data/category/repositories/category_repositories_impl.dart';
import 'package:tez_med_client/data/category/source/category_source.dart';
import 'package:tez_med_client/data/dio_client/repositories/dio_client_repository_impl.dart';
import 'package:tez_med_client/data/dio_client/source/dio_client_source.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/profile/repositories/profile_repositories_impl.dart';
import 'package:tez_med_client/data/profile/source/profile_source.dart';
import 'package:tez_med_client/data/request_post/repositories/request_repositories_impl.dart';
import 'package:tez_med_client/data/request_post/source/request_source.dart';
import 'package:tez_med_client/data/requests_get/source/finished_request_source.dart';
import 'package:tez_med_client/data/requests_get/source/id_request_source.dart';
import 'package:tez_med_client/data/species/repositories/species_repositories_impl.dart';
import 'package:tez_med_client/data/species/source/get_nurse_type_source.dart';
import 'package:tez_med_client/data/species/source/species_source.dart';
import 'package:tez_med_client/domain/comments/repositories/comment_repositories.dart';
import 'package:tez_med_client/domain/comments/usecase/post_comment_usecase.dart';
import 'package:tez_med_client/domain/doctor/repositories/doctor_repositories.dart';
import 'package:tez_med_client/domain/doctor/useacase/doctor_usecase.dart';
import 'package:tez_med_client/domain/my_address/repositories/my_address_repositories.dart';
import 'package:tez_med_client/domain/my_address/usecase/get_my_address_usecase.dart';
import 'package:tez_med_client/domain/notification/repositories/notification_repository.dart';
import 'package:tez_med_client/domain/profile_update/repositories/profile_update_repositories.dart';
import 'package:tez_med_client/domain/profile_update/usecase/profile_update_usecase.dart';
import 'package:tez_med_client/domain/promocode/repositories/promocode_repositories.dart';
import 'package:tez_med_client/domain/promocode/usecase/promocode_usecase.dart';
import 'package:tez_med_client/domain/requests_get/repositories/active_request_repositories.dart';
import 'package:tez_med_client/domain/requests_get/repositories/finished_request_repositories.dart';
import 'package:tez_med_client/domain/requests_get/repositories/id_request_repositories.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_active_request_usecase.dart';
import 'package:tez_med_client/domain/add_client/repositories/add_client_repositories.dart';
import 'package:tez_med_client/domain/add_client/usecase/add_client_usecase.dart';
import 'package:tez_med_client/domain/auth/repository/sent_otp_repository.dart';
import 'package:tez_med_client/domain/auth/repository/verify_otp_repository.dart';
import 'package:tez_med_client/domain/auth/usecase/send_otp_usecase.dart';
import 'package:tez_med_client/domain/auth/usecase/verify_otp_usecase.dart';
import 'package:tez_med_client/domain/category/repository/category_repositories.dart';
import 'package:tez_med_client/domain/category/usecase/get_category_usecase.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import 'package:tez_med_client/domain/profile/repositories/profile_repositories.dart';
import 'package:tez_med_client/domain/profile/usecase/get_client_usecase.dart';
import 'package:tez_med_client/domain/request_post/repositories/request_repositories.dart';
import 'package:tez_med_client/domain/request_post/usecase/post_request_usecase.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_by_id_request_usecase.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_finished_request_usecase.dart';
import 'package:tez_med_client/domain/species/repositories/species_repositories.dart';
import 'package:tez_med_client/domain/species/usecase/get_species_usecase.dart';
import 'package:tez_med_client/domain/upload_file/usecase/upload_file_usecase.dart';
import 'data/region/repositories/region_repositories_impl.dart';
import 'data/region/source/region_source.dart';
import 'data/upload_file/repositories/upload_file_repositories_impl.dart';
import 'data/upload_file/source/upload_file_source.dart';
import 'domain/region/repositories/region_repositories.dart';
import 'domain/region/usecase/get_region_usecase.dart';
import 'domain/upload_file/repository/upload_file_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUp() async {
  // SharedPreferences ro'yxatga olish
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Local Storage Servive
  getIt.registerSingleton<LocalStorageService>(LocalStorageService());

  // Notification
  getIt.registerSingleton<NotificationRepository>(
    NotificationRepositoryImpl(),
  );
  // DioClient
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<DioClient>(DioClient(getIt<Dio>()));
  getIt.registerSingleton<DioClientRepository>(
      DioClientRepositoryImpl(getIt<DioClient>()));

  // SendOtp
  getIt.registerSingleton<SendOtpSource>(
      SendOtpSourceImpl(dioClientRepository: getIt<DioClientRepository>()));
  getIt.registerSingleton<SendOtpRepository>(
    SendOtpRepositoriesImpl(sendOtpSource: getIt<SendOtpSource>()),
  );
  getIt.registerSingleton<SendOtpUsecase>(
      SendOtpUsecase(sendOtpRepository: getIt<SendOtpRepository>()));

  // VerifyOtp
  getIt.registerSingleton<VerifyOtpSource>(
    VerifyOtpSourceImpl(getIt<DioClientRepository>()),
  );
  getIt.registerSingleton<VerifyOtpRepository>(
      VerifyOtpRepositoriesImpl(getIt<VerifyOtpSource>()));
  getIt.registerSingleton<VerifyOtpUsecase>(
      VerifyOtpUsecase(verifyOtpRepository: getIt<VerifyOtpRepository>()));

  // Get Category
  getIt.registerSingleton<CategorySource>(
      CategorySourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<CategoryRepositories>(
      CategoryRepositoriesImpl(getIt<CategorySource>()));
  getIt.registerSingleton<GetCategoryUsecase>(
      GetCategoryUsecase(getIt<CategoryRepositories>()));

  // File Upload
  getIt.registerSingleton<UploadFileSource>(UploadFileSourceImpl(getIt<Dio>()));
  getIt.registerSingleton<UploadFileRepository>(
      UploadFileRepositoriesImpl(getIt<UploadFileSource>()));
  getIt.registerSingleton<UploadFileUsecase>(
      UploadFileUsecase(getIt<UploadFileRepository>()));

  // Request
  getIt.registerSingleton<RequestSource>(
      RequestSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<RequestRepositories>(
      RequestRepositoriesImpl(getIt<RequestSource>()));
  getIt.registerSingleton<PostRequestUsecase>(
      PostRequestUsecase(getIt<RequestRepositories>()));

  // Add client
  getIt.registerSingleton<AddClientSource>(
      AddClientSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<AddClientRepositories>(
      AddClientRepositoriesImpl(getIt<AddClientSource>()));
  getIt.registerSingleton<AddClientUsecase>(
      AddClientUsecase(getIt<AddClientRepositories>()));

  // Profile
  getIt.registerSingleton<ProfileSource>(
      ProfileSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<ProfileRepositories>(
      ProfileRepositoriesImpl(getIt<ProfileSource>()));
  getIt.registerSingleton<GetClientUsecase>(
      GetClientUsecase(getIt<ProfileRepositories>()));

  // Active request
  getIt.registerSingleton<ActiveRequestSource>(
      ActiveRequestSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<ActiveRequestRepositories>(
      ActiveRequestRepositoriesImpl(getIt<ActiveRequestSource>()));
  getIt.registerSingleton<GetActiveRequestUsecase>(
      GetActiveRequestUsecase(getIt<ActiveRequestRepositories>()));

  // Finished request
  getIt.registerSingleton<FinishedRequestSource>(
    FinishedRequestSourceImpl(getIt<DioClientRepository>()),
  );
  getIt.registerSingleton<FinishedRequestRepositories>(
      FinishedRequestRepositoriesImpl(getIt<FinishedRequestSource>()));
  getIt.registerSingleton<GetFinishedRequestUsecase>(
      GetFinishedRequestUsecase(getIt<FinishedRequestRepositories>()));

  // GetById request
  getIt.registerSingleton<IdRequestSource>(
      IdRequestSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<IdRequestRepositories>(
      IdRequestRepositoriesImpl(getIt<IdRequestSource>()));
  getIt.registerSingleton<GetByIdRequestUsecase>(
      GetByIdRequestUsecase(getIt<IdRequestRepositories>()));

  // Profile Update
  getIt.registerSingleton<ProfileUpdateSource>(
      ProfileUpdateSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<ProfileUpdateRepositories>(
      ProfileUpdateRepositoriesImpl(getIt<ProfileUpdateSource>()));
  getIt.registerSingleton<ProfileUpdateUsecase>(
      ProfileUpdateUsecase(getIt<ProfileUpdateRepositories>()));

  // My Address
  getIt.registerSingleton<MyAddressSource>(
      MyAddressSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<MyAddressRepositories>(
      MyAddressRepositoriesImpl(getIt<MyAddressSource>()));
  getIt.registerSingleton<GetMyAddressUsecase>(
      GetMyAddressUsecase(getIt<MyAddressRepositories>()));

  // Region
  getIt.registerSingleton<RegionSource>(
      RegionSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<RegionRepositories>(
      RegionRepositoriesImpl(getIt<RegionSource>()));
  getIt.registerSingleton<GetRegionUsecase>(
      GetRegionUsecase(getIt<RegionRepositories>()));

  // Promocode
  getIt.registerSingleton<PromocodeSource>(
      PromocodeSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<PromocodeRepositories>(
      PromocodeRepositoriesImpl(getIt<PromocodeSource>()));
  getIt.registerSingleton<PromocodeUsecase>(
      PromocodeUsecase(getIt<PromocodeRepositories>()));

  // Comment
  getIt.registerSingleton<CommentSource>(
      CommentSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<CommentRepositories>(
      CommentRepositoriesImpl(getIt<CommentSource>()));
  getIt.registerSingleton<PostCommentUsecase>(
      PostCommentUsecase(getIt<CommentRepositories>()));

  // Species
  getIt.registerSingleton<SpeciesSource>(
      SpeciesSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<SpeciesRepositories>(
      SpeciesRepositoriesImpl(getIt<SpeciesSource>()));
  getIt.registerSingleton<GetSpeciesUsecase>(
      GetSpeciesUsecase(getIt<SpeciesRepositories>()));

  // Nurse Type
  getIt.registerSingleton<GetNurseTypeSource>(
      GetNurseTypeSourceImpl(getIt<DioClientRepository>()));

  // Doctor
  getIt.registerSingleton<DoctorSource>(
      DoctorSourceImpl(getIt<DioClientRepository>()));
  getIt.registerSingleton<DoctorRepositories>(
      DoctorRepositoriesImpl(getIt<DoctorSource>()));
  getIt.registerSingleton<DoctorUsecase>(
      DoctorUsecase(getIt<DoctorRepositories>()));

  // Banner
  getIt.registerSingleton<GetBannerSource>(
      GetBannerSourceImpl(getIt<DioClientRepository>()));
}
