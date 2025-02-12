part of 'species_get_by_id_bloc.dart';

sealed class SpeciesGetByIdEvent extends Equatable {
  const SpeciesGetByIdEvent();

  @override
  List<Object> get props => [];
}

class GetByIdSpecies extends SpeciesGetByIdEvent {
  final String id;

  const GetByIdSpecies(this.id);

  @override
  List<Object> get props => [id];
}
