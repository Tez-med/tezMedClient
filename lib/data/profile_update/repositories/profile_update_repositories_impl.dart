import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/profile_update/model/profile_update_model.dart';
import 'package:tez_med_client/data/profile_update/source/profile_update_source.dart';
import 'package:tez_med_client/domain/profile_update/repositories/profile_update_repositories.dart';

class ProfileUpdateRepositoriesImpl implements ProfileUpdateRepositories {
  final ProfileUpdateSource profileUpdateSource;

  ProfileUpdateRepositoriesImpl(this.profileUpdateSource);

  @override
  Future<Either<Failure, ProfileUpdateModel>> updateProfile(
      ProfileUpdateModel profile) async {
    return await profileUpdateSource.updateProfile(profile);
  }
}
