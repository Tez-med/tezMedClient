import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/domain/requests_get/usecase/get_by_id_request_usecase.dart';

part 'get_by_id_request_event.dart';
part 'get_by_id_request_state.dart';

class GetByIdRequestBloc
    extends Bloc<GetByIdRequestEvent, GetByIdRequestState> {
  final GetByIdRequestUsecase getByIdRequestUsecase;

  GetByIdRequestBloc(this.getByIdRequestUsecase)
      : super(GetByIdRequestInitial()) {
    on<GetByIdRequest>(_onGetByIdRequest);
    on<GetByIdRequestNotLoading>(_onGetByIdRequestNotLoading);
  }
  Future<void> _onGetByIdRequestNotLoading(
      GetByIdRequestNotLoading event, Emitter<GetByIdRequestState> emit) async {
    final result = await getByIdRequestUsecase.getByIdRequest(event.id);
    result.fold(
      (error) => emit(GetByIdRequestError(error)),
      (data) => emit(GetByIdRequestLoaded(data)),
    );
  }

  Future<void> _onGetByIdRequest(
      GetByIdRequest event, Emitter<GetByIdRequestState> emit) async {
    emit(GetByIdRequestLoading());
    final result = await getByIdRequestUsecase.getByIdRequest(event.id);
    result.fold(
      (error) => emit(GetByIdRequestError(error)),
      (data) => emit(GetByIdRequestLoaded(data)),
    );
  }
}
