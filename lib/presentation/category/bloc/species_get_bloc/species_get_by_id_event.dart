part of 'species_get_by_id_bloc.dart';

sealed class SpeciesGetByIdEvent extends Equatable {
  const SpeciesGetByIdEvent();

  @override
  List<Object> get props => [];
}

class GetByIdSpecies extends SpeciesGetByIdEvent {
  final String id;
  final String? district;

  const GetByIdSpecies(this.id, [this.district]);

  @override
  List<Object> get props => [id, if (district != null) district!];
}
