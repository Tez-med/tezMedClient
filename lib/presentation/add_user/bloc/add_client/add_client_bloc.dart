import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/add_client/model/add_client_model.dart';
import 'package:tez_med_client/domain/add_client/usecase/add_client_usecase.dart';

part 'add_client_event.dart';
part 'add_client_state.dart';

class AddClientBloc extends Bloc<AddClientEvent, AddClientState> {
  final AddClientUsecase addClientUsecase;
  AddClientBloc(this.addClientUsecase) : super(AddClientInitial()) {
    on<AddClient>(_onAddClient);
  }

  Future<void> _onAddClient(
      AddClient event, Emitter<AddClientState> emit) async {
    emit(AddClientLoading());
    final result = await addClientUsecase.addClient(event.addClientModel);
    result.fold(
      (error) => emit(AddClientError(error)),
      (data) => emit(AddClientLoaded()),
    );
  }
}
