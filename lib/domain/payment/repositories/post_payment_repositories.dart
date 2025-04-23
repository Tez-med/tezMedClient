import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/domain/payment/entity/post_payment.dart';

abstract class PostPaymentRepositories {
  Future<Either<Failure, String>> postPayment(PostPayment postPayment);
}
