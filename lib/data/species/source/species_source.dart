import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/species/model/species_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

import '../../../core/error/error_handler.dart';

abstract class SpeciesSource {
  Future<Either<Failure, SpeciesModel>> getSpecies();
  Future<Either<Failure, Speciess>> getByIdSpecies(String id);
}

class SpeciesSourceImpl implements SpeciesSource {
  final DioClientRepository dioClientRepository;
  SpeciesSourceImpl(this.dioClientRepository);

  @override
  Future<Either<Failure, SpeciesModel>> getSpecies() async {
    try {
      final response = await dioClientRepository.getData("/species/");
      final data = SpeciesModel.fromJson(response.data);

      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }

  @override
  Future<Either<Failure, Speciess>> getByIdSpecies(String id) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response =
          await dioClientRepository.getData("/species/$id", token: token);
      final data = Speciess.fromJson(response.data);

      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {

      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
