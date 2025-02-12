part of 'doctor_request_bloc.dart';

sealed class DoctorRequestEvent extends Equatable {
  const DoctorRequestEvent();

  @override
  List<Object> get props => [];
}

class DoctorRequest extends DoctorRequestEvent {
  final DoctorRequestModel doctorRequestModel;
  final String id;
  const DoctorRequest(this.doctorRequestModel, this.id);
}
