import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/profile_update/model/profile_update_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import 'dart:developer' as developer;

abstract class ProfileUpdateSource {
  Future<Either<Failure, ProfileUpdateModel>> updateProfile(
      ProfileUpdateModel profile);
}

class ProfileUpdateSourceImpl implements ProfileUpdateSource {
  final DioClientRepository dioClientRepository;
  ProfileUpdateSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, ProfileUpdateModel>> updateProfile(
      ProfileUpdateModel profile) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    final id = LocalStorageService().getString(StorageKeys.userId);
    try {
      developer.log(profile.fcmToken,name: "FcmToken");
      final response = await dioClientRepository
          .updateData("/client/$id", profile.toJson(), token: token);
      final data = ProfileUpdateModel.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
