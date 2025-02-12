part of 'verify_otp_bloc.dart';

abstract class VerifyOtpState {}

class InitialVerifyState extends VerifyOtpState {}

class LoadingVerifyState extends VerifyOtpState {}

class SuccessVerifyState extends VerifyOtpState {}

class ErrorVerifyState extends VerifyOtpState {
  final Failure error;
  ErrorVerifyState(this.error);
}
