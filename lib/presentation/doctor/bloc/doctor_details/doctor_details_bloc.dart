import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/doctor/model/basic_doctor_model.dart';
import 'package:tez_med_client/domain/doctor/useacase/doctor_usecase.dart';

part 'doctor_details_event.dart';
part 'doctor_details_state.dart';

class DoctorDetailsBloc extends Bloc<DoctorDetailsEvent, DoctorDetailsState> {
  final DoctorUsecase doctorUsecase;
  DoctorDetailsBloc(this.doctorUsecase) : super(DoctorDetailsInitial()) {
    on<GetIdDoctor>(_onGetIdDoctor);
  }

  Future<void> _onGetIdDoctor(
      GetIdDoctor event, Emitter<DoctorDetailsState> emit) async {
    emit(DoctorDetailsLoading());
    final result = await doctorUsecase.getIdDoctor(event.id);

    result.fold(
      (error) => emit(DoctorDetailsError(error)),
      (data) => emit(DoctorDetailsLoaded(data)),
    );
  }
}
