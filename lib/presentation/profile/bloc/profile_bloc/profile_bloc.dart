import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';
import 'package:tez_med_client/domain/profile/usecase/get_client_usecase.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetClientUsecase getClientUsecase;
  
  ProfileBloc(this.getClientUsecase) // Constructor yangilandi
      : super(ProfileInitial()) {
    on<GetProfileData>(_onGetProfileData);
    on<DeleteProfile>(_onDeleteProfile); // Yangi event handler
  }

  Future<void> _onGetProfileData(
      GetProfileData event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await getClientUsecase.getData();
    result.fold(
      (error) => emit(ProfileError(error)),
      (data) => emit(ProfileLoaded(data)),
    );
  }
  
  Future<void> _onDeleteProfile(
      DeleteProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileDeletionLoading());
    final result = await getClientUsecase.deleteAccount();
    result.fold(
      (error) => emit(ProfileDeletionError(error)),
      (success) => emit(ProfileDeletionSuccess()),
    );
  }
}