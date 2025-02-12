part of 'doctor_bloc.dart';

sealed class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object> get props => [];
}

final class DoctorInitial extends DoctorState {}

final class DoctorLoading extends DoctorState {}

final class DoctorLoaded extends DoctorState {
  final DoctorModel data;
  const DoctorLoaded(this.data);
}

final class DoctorError extends DoctorState {
  final Failure error;
  const DoctorError(this.error);
}
