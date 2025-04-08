import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/disease/model/disease_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

abstract class DiseaseSource {
  Future<Either<Failure, DiseaseModel>> getDiseases();
}

class DiseaseSourceImpl implements DiseaseSource {
  final DioClientRepository dioClientRepository;

  DiseaseSourceImpl({required this.dioClientRepository});

  @override
  Future<Either<Failure, DiseaseModel>> getDiseases() async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    final id = LocalStorageService().getString(StorageKeys.userId);
    try {
      final response = await dioClientRepository.getData(
        '/diseases?client_id=$id',
        token: token,
      );

      final data = DiseaseModel.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
