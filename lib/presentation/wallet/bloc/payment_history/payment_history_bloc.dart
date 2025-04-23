import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/payment_history/model/payment_history_model.dart';
import 'package:tez_med_client/domain/payment_history/usecase/get_payment_history_usecase.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  final GetPaymentHistoryUsecase getPaymentHistoryUsecase;
  PaymentHistoryBloc(this.getPaymentHistoryUsecase)
      : super(PaymentHistoryInitial()) {
    on<FilterPayments>(_onFilterPayments);
  }

  

  void _onFilterPayments(
    FilterPayments event,
    Emitter<PaymentHistoryState> emit,
  ) async {
    emit(PaymentHistoryLoading());

    final result = await getPaymentHistoryUsecase.getPayment();
    result.fold(
      (left) => emit(PaymentHistoryError(left)),
      (right) {
        final filteredPayments = switch (event.filter) {
          PaymentFilter.all => right.payments,
          PaymentFilter.positive =>
            right.payments.where((p) => p.price > 0).toList(),
          PaymentFilter.negative =>
            right.payments.where((p) => p.price < 0).toList(),
        };
        emit(PaymentHistoryLoaded(
          paymentHistoryModel: right,
          filter: event.filter,
          filteredPayments: filteredPayments,
        ));
      },
    );
  }
}
