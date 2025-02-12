import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/auth/usecase/verify_otp_usecase.dart';
import 'dart:developer' as developer;
part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpUsecase _verifyOtpUsecase;
  VerifyOtpBloc(VerifyOtpUsecase verifyOtpUsecase)
      : _verifyOtpUsecase = verifyOtpUsecase,
        super(InitialVerifyState()) {
    on<VerifyCodeEvent>(_onVerifyCodeEvent);
  }

  Future<void> _onVerifyCodeEvent(
      VerifyCodeEvent event, Emitter<VerifyOtpState> emit) async {
    emit(LoadingVerifyState());
    final result = await _verifyOtpUsecase.verifyCode(event.code, event.phone);
    result.fold(
      (error) => emit(ErrorVerifyState(error)),
      (data) {
        emit(SuccessVerifyState());
        developer.log(data.auth.accessToken, name: "AccessToken");
        LocalStorageService()
            .setString(StorageKeys.accestoken, data.auth.accessToken);
        LocalStorageService()
            .setString(StorageKeys.refreshtoken, data.auth.refreshToken);
        LocalStorageService().setString(StorageKeys.userId, data.id);
      },
    );
  }
}
