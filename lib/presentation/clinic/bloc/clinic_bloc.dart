import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/domain/clinic/usecase/clinic_usecase.dart';

part 'clinic_event.dart';
part 'clinic_state.dart';

class ClinicBloc extends Bloc<ClinicEvent, ClinicState> {
  final ClinicUsecase clinicUsecase;
  ClinicBloc(this.clinicUsecase) : super(ClinicInitial()) {
    on<ClinicEvent>((event, emit) async {
      if (event is GetClinicsEvent) {
        emit(ClinicLoading());
        final result = await clinicUsecase.getClinics();
        result.fold(
          (failure) => emit(ClinicError(failure)),
          (clinics) => emit(ClinicLoaded(clinics)),
        );
      }
    });
    on<GetFullClinicsEvent>((event, emit) async {
      emit(ClinicFullLoading());
      final result = await clinicUsecase.getFullClinics(event.id);
      result.fold(
        (failure) => emit(ClinicFullError(failure)),
        (clinic) => emit(ClinicFullLoaded(clinic)),
      );
    });
  }
}
