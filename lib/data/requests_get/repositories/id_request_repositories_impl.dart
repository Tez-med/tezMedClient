import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/data/requests_get/source/id_request_source.dart';
import 'package:tez_med_client/domain/requests_get/repositories/id_request_repositories.dart';

class IdRequestRepositoriesImpl implements IdRequestRepositories {
  final IdRequestSource idRequestSource;

  IdRequestRepositoriesImpl(this.idRequestSource);

  @override
  Future<Either<Failure, GetByIdRequestModel>> getByIdRequest(String id) async{
    return await idRequestSource.getByIdRequest(id);
  }
}
