import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import 'dart:developer' as developer;

abstract class ProfileSource {
  Future<Either<Failure, ClientModel>> getData();
}

class ProfileSourceImpl implements ProfileSource {
  final DioClientRepository dioClientRepository;

  ProfileSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, ClientModel>> getData() async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    final id = LocalStorageService().getString(StorageKeys.userId);
    try {
      final response =
          await dioClientRepository.getData("/client/$id", token: token);
      final data = ClientModel.fromJson(response.data);
      developer.log(data.id, name: "ID");
      developer.log(token, name: "token");
      developer.log(DateTime.now().toString(), name: "date time");
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
