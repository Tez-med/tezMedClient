import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/domain/auth/entity/send_otp_entity.dart';

abstract class SendOtpRepository {
  Future<Either<Failure, void>> sendOtp(SendOtpEntity sendOtp);
}