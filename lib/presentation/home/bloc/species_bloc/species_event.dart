part of 'species_bloc.dart';

sealed class SpeciesEvent extends Equatable {
  const SpeciesEvent();

  @override
  List<Object> get props => [];
}

class GetSpecies extends SpeciesEvent {
  final String id;

  const GetSpecies(this.id);

   @override
  List<Object> get props => [id];
}
