part of 'get_by_id_request_bloc.dart';

sealed class GetByIdRequestEvent extends Equatable {
  const GetByIdRequestEvent();

  @override
  List<Object> get props => [];
}

class GetByIdRequest extends GetByIdRequestEvent {
  final String id;
  const GetByIdRequest(this.id);

   @override
  List<Object> get props => [id];
}

class GetByIdRequestNotLoading extends GetByIdRequestEvent {
  final String id;
  const GetByIdRequestNotLoading(this.id);

   @override
  List<Object> get props => [id];
}


