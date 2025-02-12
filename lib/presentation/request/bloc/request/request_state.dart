part of 'request_bloc.dart';

sealed class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

final class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestLoaded extends RequestState {}

class RequestError extends RequestState {
  final Failure error;
  const RequestError(this.error);

  @override
  List<Object> get props => [error];
}
