part of 'disease_bloc.dart';

sealed class DiseaseState extends Equatable {
  const DiseaseState();

  @override
  List<Object> get props => [];
}

final class DiseaseInitial extends DiseaseState {}

final class DiseaseLoading extends DiseaseState {}

final class DiseaseLoaded extends DiseaseState {
  final List<Diseasess> diseases;

  const DiseaseLoaded(this.diseases);

  @override
  List<Object> get props => [diseases];
}

final class DiseaseError extends DiseaseState {
  final Failure error;

  const DiseaseError(this.error);

  @override
  List<Object> get props => [error];
}

final class DiseaseEmpty extends DiseaseState {}
