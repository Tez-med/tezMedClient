import 'package:tez_med_client/domain/payment/entity/post_payment.dart';

class PostPaymentModel extends PostPayment {
  PostPaymentModel(
      {required super.createdAt, required super.clientId, required super.price});
  Map<String, dynamic> toJson() {
    return {"created_at": createdAt, "client_id": clientId, "price": price};
  }
}
