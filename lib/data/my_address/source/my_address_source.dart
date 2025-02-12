import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/my_address/model/location_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

abstract class MyAddressSource {
  Future<Either<Failure, List<LocationModel>>> getMyAddress();
}

class MyAddressSourceImpl implements MyAddressSource {
  final DioClientRepository dioClientRepository;

  MyAddressSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, List<LocationModel>>> getMyAddress() async {
    final LocalStorageService localStorageService = LocalStorageService();
    final token = localStorageService.getString(StorageKeys.accestoken);
    final id = localStorageService.getString(StorageKeys.userId);
    try {
      final response = await dioClientRepository
          .getData("/client/my-addresses?client_id=$id", token: token);

      if (response.data != null && response.data is List) {
        final List<LocationModel> data = (response.data as List)
            .map((json) => LocationModel.fromJson(json))
            .toList();
        return Right(data);
      } else {
        return const Left(UnexpectedFailure(
          code: 41,
        ));
      }
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
