import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/promocode/model/promocode_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import '../../../core/error/error_handler.dart';

abstract class PromocodeSource {
  Future<Either<Failure, PromocodeModel>> getPromocode(String key);
}

class PromocodeSourceImpl implements PromocodeSource {
  final DioClientRepository dioClientRepository;

  PromocodeSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, PromocodeModel>> getPromocode(String key) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    final id = LocalStorageService().getString(StorageKeys.userId);
    try {
      final response = await dioClientRepository.getData(
          "/promocode/word?key=$key&clientId=$id&newClient=false",
          token: token);
      final data = PromocodeModel.fromJson(response.data);

      return Right(data);
    } on DioException catch (e) {
      print(e.response!.data);
      if (e.response!.data != null) {
        if (e.response!.data['error_message'] == 'count') {
          return Left(UnexpectedFailure(code: 50));
        } else if (e.response!.data['error_message'] == 'time') {
          return Left(UnexpectedFailure(code: 51));
        }
      }

      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
