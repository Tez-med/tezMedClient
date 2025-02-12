import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/species/model/nurse_type.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

import '../../core/error/error_handler.dart';

class ServicePriceSource {
  final DioClientRepository dioClientRepository;
  ServicePriceSource(this.dioClientRepository);

  Future<Either<Failure, int>> getPrice() async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);

    try {
      final response =
          await dioClientRepository.getData("/nurse-type", token: token);
      final data = NurseType.fromJson(response.data);

      final nurseType = data.types.firstWhere(
        (t) => t.type == "nurse",
        orElse: () => Type(
          id: '',
          nameUz: '',
          nameEn: '',
          nameRu: '',
          price: 0,
          type: '',
          createdAt: '',
          updatedAt: '',
        ),
      );

      return Right(nurseType.price);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
