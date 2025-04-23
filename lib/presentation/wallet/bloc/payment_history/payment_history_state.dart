part of 'payment_history_bloc.dart';

sealed class PaymentHistoryState extends Equatable {
  const PaymentHistoryState();

  @override
  List<Object> get props => [];
}

final class PaymentHistoryInitial extends PaymentHistoryState {}

final class PaymentHistoryLoading extends PaymentHistoryState {}

final class PaymentHistoryLoaded extends PaymentHistoryState {
  final PaymentHistoryModel paymentHistoryModel;
  final PaymentFilter filter;
  final List<Payment> filteredPayments;
  const  PaymentHistoryLoaded({
    required this.paymentHistoryModel,
    required this.filter,
    required this.filteredPayments,
  });
  @override
  List<Object> get props => [paymentHistoryModel];
}

final class PaymentHistoryError extends PaymentHistoryState {
  final Failure error;
  const PaymentHistoryError(this.error);
  @override
  List<Object> get props => [error];
}
