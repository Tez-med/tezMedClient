import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';

abstract class ProfileRepositories {
  Future<Either<Failure, ClientModel>> getData();
}
