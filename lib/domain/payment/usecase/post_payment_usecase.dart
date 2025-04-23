import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/domain/payment/entity/post_payment.dart';
import 'package:tez_med_client/domain/payment/repositories/post_payment_repositories.dart';

class PostPaymentUsecase {
  final PostPaymentRepositories paymentRepositories;

  PostPaymentUsecase(this.paymentRepositories);

  Future<Either<Failure, String>> postPayment(PostPayment postPayment) async {
    return await paymentRepositories.postPayment(postPayment);
  }
}
