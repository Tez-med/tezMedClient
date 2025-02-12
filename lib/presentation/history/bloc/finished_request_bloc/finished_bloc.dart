import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_finished_request_usecase.dart';

part 'finished_event.dart';
part 'finished_state.dart';

class FinishedBloc extends Bloc<FinishedEvent, FinishedState> {
  final GetFinishedRequestUsecase getFinishedRequestUsecase;
  FinishedBloc(this.getFinishedRequestUsecase) : super(FinishedInitial()) {
    on<GetFinishedRequest>(_onGetFinishedRequest);
    on<GetFinishedRequestNotLoading>(_onGetFinishedRequestNotLoading);
  }

  Future<void> _onGetFinishedRequestNotLoading(
      GetFinishedRequestNotLoading event, Emitter<FinishedState> emit) async {
    final result = await getFinishedRequestUsecase.getFinishedRequest();
    result.fold(
      (error) => emit(FinishedError(error)),
      (data) {
        final List<Requestss> sortedRequests = List.from(data.requestss)
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
        emit(FinishedLoaded(sortedRequests));
      },
    );
  }

  Future<void> _onGetFinishedRequest(
      GetFinishedRequest event, Emitter<FinishedState> emit) async {
    emit(FinishedLoading());
    final result = await getFinishedRequestUsecase.getFinishedRequest();
    result.fold(
      (error) => emit(FinishedError(error)),
      (data) {
        final List<Requestss> sortedRequests = List.from(data.requestss)
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
        emit(FinishedLoaded(sortedRequests));
      },
    );
  }
}
