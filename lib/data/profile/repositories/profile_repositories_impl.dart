import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';
import 'package:tez_med_client/data/profile/source/profile_source.dart';
import 'package:tez_med_client/domain/profile/repositories/profile_repositories.dart';

class ProfileRepositoriesImpl implements ProfileRepositories {
  final ProfileSource profileSource;
  ProfileRepositoriesImpl(this.profileSource);
  @override
  Future<Either<Failure, ClientModel>> getData() async {
    return await profileSource.getData();
  }

  @override
  Future<Either<Failure, bool>> deleteAccount() async {
    return await profileSource.deleteAccount();
  }
}
