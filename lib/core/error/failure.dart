import 'package:dio/dio.dart';

abstract class Failure {
  final int code;

  const Failure({this.code = 0});
}

class DioFailure extends Failure {
  final DioExceptionType errorType;

  const DioFailure(this.errorType, {super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.code});
}

class ServerFailure extends Failure {
  const ServerFailure({super.code});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.code});
}