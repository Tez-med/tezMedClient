import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/add_client/model/add_client_model.dart';

abstract class AddClientRepositories {
  Future<Either<Failure, void>> addClient(AddClientModel addClient);
}
