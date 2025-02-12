import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';
import 'package:tez_med_client/domain/profile/repositories/profile_repositories.dart';

class GetClientUsecase {
  final ProfileRepositories profileRepositories;

  GetClientUsecase(this.profileRepositories);

  Future<Either<Failure, ClientModel>> getData() async {
    return await profileRepositories.getData();
  }
}
