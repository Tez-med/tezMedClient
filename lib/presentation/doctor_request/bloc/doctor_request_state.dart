part of 'doctor_request_bloc.dart';

sealed class DoctorRequestState extends Equatable {
  const DoctorRequestState();

  @override
  List<Object> get props => [];
}

final class DoctorRequestInitial extends DoctorRequestState {}

final class DoctorRequestLoading extends DoctorRequestState {}

final class DoctorRequestLoaded extends DoctorRequestState {}

final class DoctorRequestError extends DoctorRequestState {
  final Failure error;
  const DoctorRequestError(this.error);
}
