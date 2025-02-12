import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/domain/request_post/usecase/post_request_usecase.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final PostRequestUsecase postRequestUsecase;
  RequestBloc(this.postRequestUsecase) : super(RequestInitial()) {
    on<PostRequest>(_onPostRequest);
  }

  Future<void> _onPostRequest(
      PostRequest event, Emitter<RequestState> emit) async {
    emit(RequestLoading());
    final result = await postRequestUsecase.postRequest(event.requestModel);
    result.fold(
      (error) => emit(RequestError(error)),
      (data) => emit(RequestLoaded()),
    );
  }
}
