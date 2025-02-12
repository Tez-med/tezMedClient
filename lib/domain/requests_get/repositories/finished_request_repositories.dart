import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';

abstract class FinishedRequestRepositories {
  Future<Either<Failure, ActiveRequest>> getFinishedRequest();
}
