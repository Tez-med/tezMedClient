part of 'active_doctor_request_bloc.dart';

sealed class ActiveDoctorRequestEvent extends Equatable {
  const ActiveDoctorRequestEvent();

  @override
  List<Object> get props => [];
}

class GetSchedule extends ActiveDoctorRequestEvent {}
