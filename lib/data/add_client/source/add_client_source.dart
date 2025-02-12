import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/add_client/model/add_client_model.dart';
import 'package:tez_med_client/data/add_client/model/client_response_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

abstract class AddClientSource {
  Future<Either<Failure, void>> addClient(AddClientModel addClient);
}

class AddClientSourceImpl implements AddClientSource {
  final DioClientRepository dioClientRepository;

  AddClientSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, void>> addClient(AddClientModel addClient) async {
    final prefs = LocalStorageService();
    print(addClient.toJson());

    try {
      final response = await dioClientRepository.postData(
          "/auth/client", addClient.toJson());
      final data = ClientResponseModel.fromJson(response.data);
      prefs.getBool(StorageKeys.isRegister);
      prefs.setString(StorageKeys.accestoken, data.auth.accessToken);
      prefs.setString(StorageKeys.refreshtoken, data.auth.refreshToken);
      prefs.setString(StorageKeys.userId, data.id);
      return const Right(null);
    } on DioException catch (e) {
      print(e.response!.data);
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
