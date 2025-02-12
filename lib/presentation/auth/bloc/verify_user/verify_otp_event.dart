part of 'verify_otp_bloc.dart';

abstract class VerifyOtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyCodeEvent extends VerifyOtpEvent {
  final  String code;
  final  String phone;

  VerifyCodeEvent(this.code,this.phone);

  @override
  List<Object?> get props => [code,phone];
}
