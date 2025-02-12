import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

abstract class ActiveRequestSource {
  Future<Either<Failure, ActiveRequest>> getActiveRequest();
}

class ActiveRequestSourceImpl implements ActiveRequestSource {
  final DioClientRepository dioClientRepository;
  ActiveRequestSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, ActiveRequest>> getActiveRequest() async {
    final id = LocalStorageService().getString(StorageKeys.userId);
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response = await dioClientRepository
          .getData("/requests/client/active?client_id=$id", token: token);
      final data = ActiveRequest.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
