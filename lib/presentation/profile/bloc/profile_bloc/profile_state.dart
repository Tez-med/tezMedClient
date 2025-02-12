part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];

  get clientModel => null;

  get error => null;
}

final class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  @override
  final ClientModel clientModel;
  const ProfileLoaded(this.clientModel);

  @override
  List<Object> get props => [clientModel];
}

class ProfileError extends ProfileState {
  @override
  final Failure error;

  const ProfileError(this.error);

  @override
  List<Object> get props => [error];
}
