import 'package:dio/dio.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/auth/models/auth_response.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/error_model.dart';

abstract class VerifyOtpSource {
  Future<Either<Failure, AuthResponse>> verifyCode(
      String code, String phoneNumber);
}

class VerifyOtpSourceImpl implements VerifyOtpSource {
  final DioClientRepository dioClientRepository;

  VerifyOtpSourceImpl(this.dioClientRepository);

  @override
  Future<Either<Failure, AuthResponse>> verifyCode(
      String code, String phoneNumber) async {
    try {
      final parsedCode = int.tryParse(code);

      final response = await dioClientRepository.postData(
        "/auth/register/client/confirm",
        {"code": parsedCode, "phone": phoneNumber},
      );
      final data = AuthResponse.fromJson(response.data);
      return Right(data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final error = ErrorModel.fromJson(e.response!.data);

        if (error.errorcode == 404) {
          return const Left(UnexpectedFailure(code: 404));
        } else if (error.errorcode == 400) {
          return const Left(UnexpectedFailure(code: 400));
        } else if (error.errorcode == 401) {
          return const Left(UnexpectedFailure(code: 401));
        }
      }

      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }
}
