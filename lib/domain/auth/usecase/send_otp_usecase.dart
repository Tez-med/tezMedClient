
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/domain/auth/entity/send_otp_entity.dart';
import 'package:tez_med_client/domain/auth/repository/sent_otp_repository.dart';

class SendOtpUsecase {
  final SendOtpRepository _sendOtpRepository;

  SendOtpUsecase({required SendOtpRepository sendOtpRepository})
      : _sendOtpRepository = sendOtpRepository;

  Future<Either<Failure, void>> sendOtp(SendOtpEntity sendOtp) async {
    return await _sendOtpRepository.sendOtp(sendOtp);
  }
}
