part of 'get_by_id_request_bloc.dart';

sealed class GetByIdRequestState extends Equatable {
  const GetByIdRequestState();

  @override
  List<Object> get props => [];
}

final class GetByIdRequestInitial extends GetByIdRequestState {}

final class GetByIdRequestLoading extends GetByIdRequestState {}

final class GetByIdRequestLoaded extends GetByIdRequestState {
  final GetByIdRequestModel requestss;
  const GetByIdRequestLoaded(this.requestss);

  @override
  List<Object> get props => [requestss];
}

final class GetByIdRequestError extends GetByIdRequestState {
  final Failure error;
  const GetByIdRequestError(this.error);

  @override
  List<Object> get props => [error];
}
