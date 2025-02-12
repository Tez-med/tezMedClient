import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/species/model/nurse_type.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

import '../../../core/error/error_handler.dart';

abstract class GetNurseTypeSource {
  Future<Either<Failure, NurseType>> getType();
}

class GetNurseTypeSourceImpl implements GetNurseTypeSource {
  final DioClientRepository dioClientRepository;
  GetNurseTypeSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, NurseType>> getType() async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response =
          await dioClientRepository.getData("/nurse-type", token: token);
      final data = NurseType.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
