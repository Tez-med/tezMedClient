import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/profile_update/model/profile_update_model.dart';

abstract class ProfileUpdateRepositories {
  Future<Either<Failure, ProfileUpdateModel>> updateProfile(ProfileUpdateModel profile);
}
