part of 'species_bloc.dart';

sealed class SpeciesEvent extends Equatable {
  const SpeciesEvent();

  @override
  List<Object> get props => [];
}

class GetSpecies extends SpeciesEvent {}
