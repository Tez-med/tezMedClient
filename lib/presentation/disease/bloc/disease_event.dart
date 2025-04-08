part of 'disease_bloc.dart';

sealed class DiseaseEvent extends Equatable {
  const DiseaseEvent();

  @override
  List<Object> get props => [];
}

class FetchDiseases extends DiseaseEvent {}
