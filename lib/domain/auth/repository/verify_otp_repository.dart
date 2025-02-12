import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import '../../../data/auth/models/auth_response.dart';


abstract class VerifyOtpRepository {
  Future<Either<Failure, AuthResponse>> verifyCode(
      String code, String phoneNumber);
}
