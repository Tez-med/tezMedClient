import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';

abstract class IdRequestRepositories {
  Future<Either<Failure, GetByIdRequestModel>> getByIdRequest(String id);
}
