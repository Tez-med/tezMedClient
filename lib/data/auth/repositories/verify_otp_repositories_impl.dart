import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/auth/models/auth_response.dart';
import 'package:tez_med_client/data/auth/source/verify_otp_source.dart';
import 'package:tez_med_client/domain/auth/repository/verify_otp_repository.dart';

class VerifyOtpRepositoriesImpl extends VerifyOtpRepository {
  final VerifyOtpSource verifyOtpSource;

  VerifyOtpRepositoriesImpl(this.verifyOtpSource);

  @override
  Future<Either<Failure, AuthResponse>> verifyCode(
      String code, String phoneNumber) async {
    return await verifyOtpSource.verifyCode(code, phoneNumber);
  }
}
