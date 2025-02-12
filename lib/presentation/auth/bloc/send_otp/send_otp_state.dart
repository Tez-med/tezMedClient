part of 'send_otp_bloc.dart';

abstract class SendOtpState {}

class InitialOtp extends SendOtpState {}

class LoadingOtp extends SendOtpState {}

class SuccessOtp extends SendOtpState {
}

class ErrorOtp extends SendOtpState {
  Failure error;
  ErrorOtp(this.error);
}
