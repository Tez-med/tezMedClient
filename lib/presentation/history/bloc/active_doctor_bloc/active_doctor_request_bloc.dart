import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/schedule/model/schedule_model.dart';
import 'package:tez_med_client/domain/schedule/usecase/schedule_usecase.dart';

part 'active_doctor_request_event.dart';
part 'active_doctor_request_state.dart';

class ActiveDoctorRequestBloc
    extends Bloc<ActiveDoctorRequestEvent, ActiveDoctorRequestState> {
  final ScheduleUsecase scheduleUsecase;
  ActiveDoctorRequestBloc(this.scheduleUsecase)
      : super(ActiveDoctorRequestInitial()) {
    on<GetSchedule>(_onGetSchedule);
  }

  Future<void> _onGetSchedule(
      GetSchedule event, Emitter<ActiveDoctorRequestState> emit) async {
    emit(ActiveDoctorRequestLoading());
    final result = await scheduleUsecase
        .getSchedule(LocalStorageService().getString(StorageKeys.userId));
    result.fold(
      (error) => emit(ActiveDoctorRequestError(error)),
      (data) => emit(ActiveDoctorRequestLoaded(data)),
    );
  }
}
