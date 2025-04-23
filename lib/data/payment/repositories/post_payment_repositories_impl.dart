import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/payment/model/post_payment_model.dart';
import 'package:tez_med_client/data/payment/source/post_payment_source.dart';
import 'package:tez_med_client/domain/payment/entity/post_payment.dart';
import 'package:tez_med_client/domain/payment/repositories/post_payment_repositories.dart';

class PostPaymentRepositoriesImpl implements PostPaymentRepositories {
  final PostPaymentSource postPaymentSource;
  PostPaymentRepositoriesImpl(this.postPaymentSource);

  @override
  Future<Either<Failure, String>> postPayment(PostPayment postPayment) async {
    return postPaymentSource.postPayment(
      PostPaymentModel(
        createdAt: postPayment.createdAt,
        clientId: postPayment.clientId,
        price: postPayment.price,
      ),
    );
  }
}
