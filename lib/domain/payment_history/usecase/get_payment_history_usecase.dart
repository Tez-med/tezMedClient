import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/payment_history/model/payment_history_model.dart';
import 'package:tez_med_client/domain/payment_history/repositories/payment_history_repositories.dart';

class GetPaymentHistoryUsecase {
  final PaymentHistoryRepositories paymentHistoryRepositories;

  GetPaymentHistoryUsecase(this.paymentHistoryRepositories);

  Future<Either<Failure, PaymentHistoryModel>> getPayment() async {
    return await paymentHistoryRepositories.getPayment();
  }
}
