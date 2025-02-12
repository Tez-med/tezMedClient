import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/auth/models/send_otp_model.dart';
import 'package:tez_med_client/data/auth/source/send_otp_source.dart';
import 'package:tez_med_client/domain/auth/entity/send_otp_entity.dart';
import 'package:tez_med_client/domain/auth/repository/sent_otp_repository.dart';

class SendOtpRepositoriesImpl implements SendOtpRepository {
  final SendOtpSource _sendOtpSource;
  SendOtpRepositoriesImpl({required SendOtpSource sendOtpSource})
      : _sendOtpSource = sendOtpSource;
  @override
  Future<Either<Failure, void>> sendOtp(SendOtpEntity sendOtp) async {
    final request = SendOtpModel(
        phoneNumber: sendOtp.phoneNumber,
        appSignatureCode: sendOtp.appSignatureCode);
    return await _sendOtpSource.sendOtp(request);
  }
}
