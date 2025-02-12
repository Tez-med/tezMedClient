import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/profile_update/model/profile_update_model.dart';
import 'package:tez_med_client/domain/profile_update/usecase/profile_update_usecase.dart';

part 'profile_update_event.dart';
part 'profile_update_state.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  final ProfileUpdateUsecase profileUpdateUsecase;
  ProfileUpdateBloc(this.profileUpdateUsecase) : super(ProfileUpdateInitial()) {
    on<ProfileUpdate>(_onProfileUpdate);
  }

  Future<void> _onProfileUpdate(
      ProfileUpdate event, Emitter<ProfileUpdateState> emit) async {
    emit(ProfileUpdateLoading());
    final result =
        await profileUpdateUsecase.updateProfile(event.profileUpdateModel);
    result.fold(
      (error) => emit(ProfileUpdateError(error)),
      (data) => emit(ProfileUpdateLoaded()),
    );
  }
}
