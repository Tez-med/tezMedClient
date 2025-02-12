import 'dart:async';
import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

abstract class IdRequestSource {
  Future<Either<Failure, GetByIdRequestModel>> getByIdRequest(String id);
}

class IdRequestSourceImpl implements IdRequestSource {
  final DioClientRepository dioClientRepository;

  IdRequestSourceImpl(this.dioClientRepository);

  @override
  Future<Either<Failure, GetByIdRequestModel>> getByIdRequest(String id) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response =
          await dioClientRepository.getData("/requests/$id", token: token);
      final data = GetByIdRequestModel.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
