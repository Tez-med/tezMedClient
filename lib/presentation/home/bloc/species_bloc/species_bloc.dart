import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/species/model/species_model.dart';
import 'package:tez_med_client/domain/species/usecase/get_species_usecase.dart';

part 'species_event.dart';
part 'species_state.dart';

class SpeciesBloc extends Bloc<SpeciesEvent, SpeciesState> {
  final GetSpeciesUsecase getSpeciesUsecase;
  SpeciesBloc(this.getSpeciesUsecase) : super(SpeciesInitial()) {
    on<GetSpecies>(_onGetSpecies);
  }

  Future<void> _onGetSpecies(
      GetSpecies event, Emitter<SpeciesState> emit) async {
    emit(SpeciesLoading());
    final result = await getSpeciesUsecase.getSpecies(event.id);

    result.fold(
      (error) => emit(SpeciesError(error)),
      (data) => emit(SpeciesLoaded(data)),
    );
  }
}
