part of 'active_request_bloc.dart';

sealed class ActiveRequestState extends Equatable {
  const ActiveRequestState();

  @override
  List<Object> get props => [];
}

class ActiveRequestInitial extends ActiveRequestState {}

class ActiveRequestLoading extends ActiveRequestState {}

class ActiveRequestLoaded extends ActiveRequestState {
  final List<Requestss> requestss;
  const ActiveRequestLoaded(this.requestss);

  @override
  List<Object> get props => [requestss];
}

class ActiveRequestError extends ActiveRequestState {
  final Failure error;

  const ActiveRequestError(this.error);

  @override
  List<Object> get props => [error];
}
