part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileData extends ProfileEvent {}
class DeleteProfile extends ProfileEvent {}
