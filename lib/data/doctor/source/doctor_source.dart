import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/doctor/model/doctor_model.dart';
import 'package:tez_med_client/data/doctor/model/doctor_request_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

import '../../../core/error/error_handler.dart';
import '../model/basic_doctor_model.dart';

abstract class DoctorSource {
  Future<Either<Failure, DoctorModel>> getDoctor(String id);
  Future<Either<Failure, BasicDoctorModel>> getIdDoctor(String id);
  Future<Either<Failure, void>> doctorRequest(
      DoctorRequestModel request, String id);
}

class DoctorSourceImpl implements DoctorSource {
  final DioClientRepository dioClientRepository;
  DoctorSourceImpl(this.dioClientRepository);

  @override
  Future<Either<Failure, DoctorModel>> getDoctor(String id) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response = await dioClientRepository
          .getData("/doctor?nurse_type_id=$id", token: token);
      final data = DoctorModel.fromJson(response.data);

      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }

  @override
  Future<Either<Failure, BasicDoctorModel>> getIdDoctor(String id) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response =
          await dioClientRepository.getData("/doctor/$id", token: token);
      final data = BasicDoctorModel.fromJson(response.data);

      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }

  @override
  Future<Either<Failure, void>> doctorRequest(
      DoctorRequestModel request, String id) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      await dioClientRepository.updateData(
        "/schedule/$id",
        request.toJson(),
        token: token,
      );

      return Right(null);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
