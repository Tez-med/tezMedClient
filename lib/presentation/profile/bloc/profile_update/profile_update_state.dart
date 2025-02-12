part of 'profile_update_bloc.dart';

sealed class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();

  @override
  List<Object> get props => [];
}

final class ProfileUpdateInitial extends ProfileUpdateState {}

class ProfileUpdateLoading extends ProfileUpdateState {}

class ProfileUpdateLoaded extends ProfileUpdateState {}

class ProfileUpdateError extends ProfileUpdateState {
  final Failure error;

  const ProfileUpdateError(this.error);

  @override
  List<Object> get props => [error];
}
