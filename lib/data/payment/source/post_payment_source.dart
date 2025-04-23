import 'package:dio/dio.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/payment/model/post_payment_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import '../../../core/constant/storage_keys.dart';
import '../../local_storage/local_storage_service.dart';

abstract class PostPaymentSource {
  Future<Either<Failure, String>> postPayment(PostPaymentModel postPayment);
}

class PostPaymentSourceImpl implements PostPaymentSource {
  final DioClientRepository dioClientRepository;
  PostPaymentSourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, String>> postPayment(
      PostPaymentModel postPayment) async {
    final accessToken = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response = await dioClientRepository
          .postData("/payments/", postPayment.toJson(), token: accessToken);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnexpectedFailure(code: 40));
    }
  }
}
