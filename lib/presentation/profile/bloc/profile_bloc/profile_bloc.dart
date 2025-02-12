import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';
import 'package:tez_med_client/domain/profile/usecase/get_client_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetClientUsecase getClientUsecase;
  ProfileBloc(this.getClientUsecase) : super(ProfileInitial()) {
    on<GetProfileData>(_onGetProfileData);
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
}
