part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PostPay extends PaymentEvent {
  final PostPayment payment;

  const PostPay(this.payment);

  @override
  List<Object> get props => [payment];
}
