import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';

abstract class RequestRepositories {
  Future<Either<Failure, void>> postRequest(RequestModel request);
}
