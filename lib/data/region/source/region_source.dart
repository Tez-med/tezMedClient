import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/region/model/country_model.dart';
import 'package:tez_med_client/data/region/model/region_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

abstract class RegionSource {
  Future<Either<Failure, RegionModel>> getRegion(String countryId);
  Future<Either<Failure, CountryModel>> getCountry();
}

class RegionSourceImpl implements RegionSource {
  final DioClientRepository dioClientRepository;

  RegionSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, RegionModel>> getRegion(String countryId) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response =
          await dioClientRepository.getData("/region?country_id=$countryId", token: token);
      final data = RegionModel.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, CountryModel>> getCountry() async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response =
          await dioClientRepository.getData("/country", token: token);
      final data = CountryModel.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }
  
 
}
