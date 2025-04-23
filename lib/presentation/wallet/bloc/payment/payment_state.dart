part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

final class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final String url;
  const PaymentLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class PaymentError extends PaymentState {
  final Failure error;
  const PaymentError(this.error);

  @override
  List<Object> get props => [error];
}
