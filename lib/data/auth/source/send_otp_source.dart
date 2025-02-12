import 'package:dio/dio.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/auth/models/send_otp_model.dart';

import '../../../domain/dio_client/repository/dio_client_repository.dart';

abstract class SendOtpSource {
  Future<Either<Failure, void>> sendOtp(SendOtpModel sendOtp);
}

class SendOtpSourceImpl implements SendOtpSource {
  final DioClientRepository _dioClientRepository;

  SendOtpSourceImpl({required DioClientRepository dioClientRepository})
      : _dioClientRepository = dioClientRepository;

  @override
  Future<Either<Failure, void>> sendOtp(SendOtpModel sendOtp) async {
    try {
      await _dioClientRepository.postData(
        "/auth/register/send-otp",
        sendOtp.toJson(),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
