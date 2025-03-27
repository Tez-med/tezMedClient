import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/species/model/species_model.dart';
import 'package:tez_med_client/domain/species/usecase/get_species_usecase.dart';

part 'species_get_by_id_event.dart';
part 'species_get_by_id_state.dart';

class SpeciesGetByIdBloc
    extends Bloc<SpeciesGetByIdEvent, SpeciesGetByIdState> {
  final GetSpeciesUsecase getSpeciesUsecase;

  SpeciesGetByIdBloc(this.getSpeciesUsecase) : super(SpeciesGetByIdInitial()) {
    on<GetByIdSpecies>(_onGetByIdSpecies);
  }

  Future<void> _onGetByIdSpecies(
      GetByIdSpecies event, Emitter<SpeciesGetByIdState> emit) async {
    emit(SpeciesGetByIdLoading());
    final result = await getSpeciesUsecase.getByIdSpecies(event.id, event.district);

    result.fold(
      (error) => emit(SpeciesGetByIdError(error)),
      (data) => emit(SpeciesGetByIdLoaded(data)),
    );
  }
}
