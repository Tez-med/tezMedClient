import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_active_request_usecase.dart';

part 'active_request_event.dart';
part 'active_request_state.dart';

class ActiveRequestBloc extends Bloc<ActiveRequestEvent, ActiveRequestState> {
  final GetActiveRequestUsecase getActiveRequestUsecase;
  Timer? _timer;

  ActiveRequestBloc(
    this.getActiveRequestUsecase,
  ) : super(ActiveRequestInitial()) {
    on<GetActiveRequest>(_onGetActiveRequest);
    on<GetActiveRequestNotLoading>(_onGetActiveRequestNotLoading);

    // Start periodic timer to add GetActiveRequest every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(GetActiveRequestNotLoading());
    });
  }

  Future<void> _onGetActiveRequestNotLoading(GetActiveRequestNotLoading event,
      Emitter<ActiveRequestState> emit) async {
    final result = await getActiveRequestUsecase.getActiveRequest();
    result.fold(
      (error) => emit(ActiveRequestError(error)),
      (data) {
        final List<Requestss> sortedRequests = List.from(data.requestss)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(ActiveRequestLoaded(sortedRequests));
      },
    );
  }

  Future<void> _onGetActiveRequest(
      GetActiveRequest event, Emitter<ActiveRequestState> emit) async {
    emit(ActiveRequestLoading());
    final result = await getActiveRequestUsecase.getActiveRequest();
    result.fold(
      (error) => emit(ActiveRequestError(error)),
      (data) {
        final List<Requestss> sortedRequests = List.from(data.requestss)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(ActiveRequestLoaded(sortedRequests));
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
