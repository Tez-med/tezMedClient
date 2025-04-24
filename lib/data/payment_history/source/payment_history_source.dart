import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/payment_history/model/payment_history_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

import '../../../core/error/error_handler.dart';

abstract class PaymentHistorySource {
  Future<Either<Failure, PaymentHistoryModel>> getPayment();
}

class PaymentHistorySourceImpl implements PaymentHistorySource {
  final DioClientRepository dioClientRepository;

  PaymentHistorySourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, PaymentHistoryModel>> getPayment() async {
    final id = LocalStorageService().getString(StorageKeys.userId);
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response = await dioClientRepository
          .getData('/payments?client_id=$id', token: token);
      final data = PaymentHistoryModel.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnexpectedFailure(code: 40));
    }
  }
}
