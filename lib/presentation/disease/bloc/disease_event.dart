part of 'disease_bloc.dart';

sealed class DiseaseEvent extends Equatable {
  const DiseaseEvent();

  @override
  List<Object> get props => [];
}

class FetchDiseases extends DiseaseEvent {}

class CreateDisease extends DiseaseEvent {
  final DiseasePost diseasePost;

  const CreateDisease(this.diseasePost);

  @override
  List<Object> get props => [diseasePost];
}
