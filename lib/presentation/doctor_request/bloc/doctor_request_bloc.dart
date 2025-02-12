import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/doctor/model/doctor_request_model.dart';
import 'package:tez_med_client/domain/doctor/useacase/doctor_usecase.dart';

part 'doctor_request_event.dart';
part 'doctor_request_state.dart';

class DoctorRequestBloc extends Bloc<DoctorRequestEvent, DoctorRequestState> {
  final DoctorUsecase doctorUsecase;

  DoctorRequestBloc(this.doctorUsecase) : super(DoctorRequestInitial()) {
    on<DoctorRequest>(_onDoctorRequest);
  }

  Future<void> _onDoctorRequest(
      DoctorRequest event, Emitter<DoctorRequestState> emit) async {
    emit(DoctorRequestLoading());

    final result =
        await doctorUsecase.doctorRequest(event.doctorRequestModel, event.id);
    result.fold(
      (error) => emit(DoctorRequestError(error)),
      (right) => emit(DoctorRequestLoaded()),
    );
  }
}
