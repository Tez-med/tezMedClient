part of 'profile_update_bloc.dart';

sealed class ProfileUpdateEvent extends Equatable {
  const ProfileUpdateEvent();

  @override
  List<Object> get props => [];
}

class ProfileUpdate extends ProfileUpdateEvent {
  final ProfileUpdateModel profileUpdateModel;

  const ProfileUpdate(this.profileUpdateModel);
  @override
  List<Object> get props => [profileUpdateModel];
}
