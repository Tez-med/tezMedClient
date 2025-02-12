part of 'request_bloc.dart';

sealed class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class PostRequest extends RequestEvent {
  final RequestModel requestModel;
  const PostRequest(this.requestModel);

  @override
  List<Object> get props => [requestModel];
}
