part of 'finished_bloc.dart';

sealed class FinishedEvent extends Equatable {
  const FinishedEvent();

  @override
  List<Object> get props => [];
}

class GetFinishedRequest extends FinishedEvent {}

class GetFinishedRequestNotLoading extends FinishedEvent {}
