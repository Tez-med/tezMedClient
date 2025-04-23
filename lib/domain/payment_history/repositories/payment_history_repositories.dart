import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/payment_history/model/payment_history_model.dart';

abstract class PaymentHistoryRepositories {
  Future<Either<Failure,PaymentHistoryModel>> getPayment();
}