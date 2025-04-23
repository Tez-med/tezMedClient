part of 'payment_history_bloc.dart';

sealed class PaymentHistoryEvent extends Equatable {
  const PaymentHistoryEvent();

  @override
  List<Object> get props => [];
}

class FilterPayments extends PaymentHistoryEvent {
  final PaymentFilter filter;
  const FilterPayments(this.filter);
}

enum PaymentFilter { all, positive, negative }
