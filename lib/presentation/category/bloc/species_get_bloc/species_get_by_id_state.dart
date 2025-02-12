part of 'species_get_by_id_bloc.dart';

sealed class SpeciesGetByIdState extends Equatable {
  const SpeciesGetByIdState();

  @override
  List<Object> get props => [];
}

final class SpeciesGetByIdInitial extends SpeciesGetByIdState {}

final class SpeciesGetByIdLoading extends SpeciesGetByIdState {}

final class SpeciesGetByIdLoaded extends SpeciesGetByIdState {
  final Speciess speciesModel;

  const SpeciesGetByIdLoaded(this.speciesModel);
  @override
  List<Object> get props => [speciesModel];
}

final class SpeciesGetByIdError extends SpeciesGetByIdState {
  final Failure error;

  const SpeciesGetByIdError(this.error);

  @override
  List<Object> get props => [error];
}
