
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/auth/models/auth_response.dart';
import 'package:tez_med_client/domain/auth/repository/verify_otp_repository.dart';

class VerifyOtpUsecase {
  final VerifyOtpRepository _verifyOtpRepository;

  VerifyOtpUsecase({required VerifyOtpRepository verifyOtpRepository})
      : _verifyOtpRepository = verifyOtpRepository;
  Future<Either<Failure, AuthResponse>> verifyCode(
      String code, String phoneNumber) async {
    return await _verifyOtpRepository.verifyCode(code, phoneNumber);
  }
}
