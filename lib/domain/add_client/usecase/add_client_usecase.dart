import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/add_client/model/add_client_model.dart';
import 'package:tez_med_client/domain/add_client/repositories/add_client_repositories.dart';

class AddClientUsecase {
  final AddClientRepositories addClientRepositories;

  AddClientUsecase(this.addClientRepositories);

  Future<Either<Failure, void>> addClient(AddClientModel addClient) async {
    return await addClientRepositories.addClient(addClient);
  }
}
