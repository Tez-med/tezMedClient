import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/doctor/model/doctor_model.dart';
import 'package:tez_med_client/domain/doctor/useacase/doctor_usecase.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorUsecase doctorUsecase;
  DoctorBloc(this.doctorUsecase) : super(DoctorInitial()) {
    on<GetDoctor>(_onGetDoctor);
  }

  Future<void> _onGetDoctor(GetDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    final result = await doctorUsecase.getDoctor(event.id);
    result.fold(
      (error) => emit(DoctorError(error)),
      (data) => emit(DoctorLoaded(data)),
    );
  }
}
