import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import 'dart:developer' as developer;

abstract class RequestSource {
  Future<Either<Failure, void>> postRequest(RequestModel request);
}

class RequestSourceImpl implements RequestSource {
  final DioClientRepository dioClientRepository;

  RequestSourceImpl(this.dioClientRepository);

  @override
  Future<Either<Failure, void>> postRequest(RequestModel request) async {
    developer.log(request.toJson().toString(), name: "Request");
    try {
      final token = LocalStorageService().getString(StorageKeys.accestoken);
      final response = await dioClientRepository
          .postData("/requests/", request.toJson(), token: token);

      // response.data ni Map yoki String ga qarab ishlatish
      if (response.data is Map) {
        developer.log(response.data.toString(), name: "RESPONSE");
      } else {
        developer.log(response.data, name: "RESPONSE");
      }

      return const Right(null);
    } on DioException catch (e) {
      developer.log(e.toString(), name: "ERROR 1");
      if (e.response?.data is Map) {
        developer.log(e.response!.data.toString(), name: "ERROR");
      } else {
        developer.log(e.response?.data.toString() ?? "No error data",
            name: "ERROR");
      }

      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      developer.log(e.toString(), name: "ERROR");
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
