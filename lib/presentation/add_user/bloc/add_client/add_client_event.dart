part of 'add_client_bloc.dart';

sealed class AddClientEvent extends Equatable {
  const AddClientEvent();

  @override
  List<Object> get props => [];
}

class AddClient extends AddClientEvent {
  final AddClientModel addClientModel;

  const AddClient(this.addClientModel);

  @override
  List<Object> get props => [addClientModel];
}
