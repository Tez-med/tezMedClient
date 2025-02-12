part of 'active_request_bloc.dart';

sealed class ActiveRequestEvent extends Equatable {
  const ActiveRequestEvent();

  @override
  List<Object> get props => [];
}

class GetActiveRequest extends ActiveRequestEvent {}

class GetActiveRequestNotLoading extends ActiveRequestEvent {}

