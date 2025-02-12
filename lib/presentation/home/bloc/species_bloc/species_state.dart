part of 'species_bloc.dart';

sealed class SpeciesState extends Equatable {
  const SpeciesState();

  @override
  List<Object> get props => [];
}

final class SpeciesInitial extends SpeciesState {}

final class SpeciesLoading extends SpeciesState {}

final class SpeciesLoaded extends SpeciesState {
  final SpeciesModel speciesModel;

  const SpeciesLoaded(this.speciesModel);
  @override
  List<Object> get props => [speciesModel];
}

final class SpeciesError extends SpeciesState {
  final Failure error;
  const SpeciesError(this.error);
  @override
  List<Object> get props => [error];
}
