part of 'send_otp_bloc.dart';

abstract class SendOtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendCodeEvent extends SendOtpEvent {
  final SendOtpEntity sendOtp;

  SendCodeEvent({required this.sendOtp});

  @override
  List<Object?> get props => [sendOtp];
}
