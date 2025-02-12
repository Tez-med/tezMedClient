import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/domain/auth/entity/send_otp_entity.dart';
import 'package:tez_med_client/domain/auth/usecase/send_otp_usecase.dart';

part 'send_otp_event.dart';
part 'send_otp_state.dart';

class SendOtpBloc extends Bloc<SendOtpEvent, SendOtpState> {
  final SendOtpUsecase _sendOtpUsecase;

  SendOtpBloc({required SendOtpUsecase sendOtpUsecase})
      : _sendOtpUsecase = sendOtpUsecase,
        super(InitialOtp()) {
    on<SendCodeEvent>(_onSendCodeEvent);
  }

  Future<void> _onSendCodeEvent(
      SendCodeEvent event, Emitter<SendOtpState> emit) async {
    emit(LoadingOtp());
    final result = await _sendOtpUsecase.sendOtp(
      SendOtpEntity(
          phoneNumber: event.sendOtp.phoneNumber,
          appSignatureCode: event.sendOtp.appSignatureCode),
    );
    result.fold(
      (error) => emit(ErrorOtp(error)),
      (data) => emit(SuccessOtp()),
    );
  }
}
