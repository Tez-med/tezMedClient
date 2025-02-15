part of 'active_doctor_request_bloc.dart';

sealed class ActiveDoctorRequestState extends Equatable {
  const ActiveDoctorRequestState();

  @override
  List<Object> get props => [];
}

final class ActiveDoctorRequestInitial extends ActiveDoctorRequestState {}

final class ActiveDoctorRequestLoading extends ActiveDoctorRequestState {}

final class ActiveDoctorRequestLoaded extends ActiveDoctorRequestState {
  final ScheduleModel scheduleModel;
  const ActiveDoctorRequestLoaded(this.scheduleModel);
}

final class ActiveDoctorRequestError extends ActiveDoctorRequestState {
  final Failure error;
  const ActiveDoctorRequestError(this.error);
}
