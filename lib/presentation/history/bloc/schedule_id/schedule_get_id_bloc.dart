import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../data/schedule/model/schedule_model.dart';
import '../../../../domain/schedule/usecase/schedule_usecase.dart';

part 'schedule_get_id_event.dart';
part 'schedule_get_id_state.dart';

class ScheduleGetIdBloc extends Bloc<ScheduleGetIdEvent, ScheduleGetIdState> {
  final ScheduleUsecase scheduleUsecase;
  ScheduleGetIdBloc(this.scheduleUsecase) : super(ScheduleGetIdInitial()) {
    on<GetScheduleId>(_onGetScheduleId);
  }

  Future<void> _onGetScheduleId(
      GetScheduleId event, Emitter<ScheduleGetIdState> emit) async {
    emit(ScheduleGetIdLoading());
    final result = await scheduleUsecase.getById(event.id);
    result.fold(
      (error) => emit(ScheduleGetIdError(error)),
      (data) => emit(ScheduleGetIdSuccess(data)),
    );
  }
}
