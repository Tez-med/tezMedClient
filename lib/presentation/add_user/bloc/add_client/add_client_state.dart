part of 'add_client_bloc.dart';

sealed class AddClientState extends Equatable {
  const AddClientState();

  @override
  List<Object> get props => [];
}

final class AddClientInitial extends AddClientState {}

class AddClientLoading extends AddClientState {}

class AddClientLoaded extends AddClientState {}

class AddClientError extends AddClientState {
  final Failure error;

  const AddClientError(this.error);

  @override
  List<Object> get props => [error];
}
