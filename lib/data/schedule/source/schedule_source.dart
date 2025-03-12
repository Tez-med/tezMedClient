import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/schedule/model/schedule_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

import '../../../core/error/error_handler.dart';

abstract class ScheduleSource {
  Future<Either<Failure, ScheduleModel>> getSchedule(String id);
  Future<Either<Failure, Schedule>> getById(String id);
}

class ScheduleSourceImpl implements ScheduleSource {
  final DioClientRepository dioClientRepository;

  ScheduleSourceImpl(this.dioClientRepository);

  @override
  Future<Either<Failure, ScheduleModel>> getSchedule(String id) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);

    try {
      final response = await dioClientRepository
          .getData("/schedule?client_id=$id", token: token);
      final data = ScheduleModel.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }

  @override
  Future<Either<Failure, Schedule>> getById(String id) async {
    final idClient = LocalStorageService().getString(StorageKeys.userId);
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response = await dioClientRepository.getData(
          '/schedule/$id?client_id=$idClient&generate_link=true',
          token: token);
      return Right(Schedule.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
