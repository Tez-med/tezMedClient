part of 'finished_bloc.dart';

sealed class FinishedState extends Equatable {
  const FinishedState();

  @override
  List<Object> get props => [];
}

final class FinishedInitial extends FinishedState {}

class FinishedLoading extends FinishedState {}

class FinishedLoaded extends FinishedState {
  final List<Requestss> requestss;
  const FinishedLoaded(this.requestss);

  @override
  List<Object> get props => [requestss];
}

class FinishedError extends FinishedState {
  final Failure error;
  const FinishedError(this.error);

  @override
  List<Object> get props => [error];
}
