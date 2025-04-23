import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/domain/payment/entity/post_payment.dart';
import 'package:tez_med_client/domain/payment/usecase/post_payment_usecase.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PostPaymentUsecase postPaymentUsecase;

  PaymentBloc(this.postPaymentUsecase) : super(PaymentInitial()) {
    on<PostPay>(_onPostPay);
  }

  Future<void> _onPostPay(PostPay event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    final result = await postPaymentUsecase.postPayment(event.payment);
    result.fold(
      (error) => emit(PaymentError(error)),
      (data) => emit(PaymentLoaded(data)),
    );
  }
}
