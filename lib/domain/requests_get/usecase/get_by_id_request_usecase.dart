import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/domain/requests_get/repositories/id_request_repositories.dart';

class GetByIdRequestUsecase {
  final IdRequestRepositories idRequestRepositories;
  GetByIdRequestUsecase(this.idRequestRepositories);

  Future<Either<Failure, GetByIdRequestModel>> getByIdRequest(String id)async {
    return await idRequestRepositories.getByIdRequest(id);
  }
}
