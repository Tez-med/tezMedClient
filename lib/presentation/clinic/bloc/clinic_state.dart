part of 'clinic_bloc.dart';

sealed class ClinicState extends Equatable {
  const ClinicState();

  @override
  List<Object> get props => [];
}

final class ClinicInitial extends ClinicState {}

final class ClinicLoading extends ClinicState {}

final class ClinicLoaded extends ClinicState {
  final ClinicsModel clinicsModel;
  const ClinicLoaded(this.clinicsModel);

  @override
  List<Object> get props => [clinicsModel];
}

final class ClinicError extends ClinicState {
  final Failure message;
  const ClinicError(this.message);

  @override
  List<Object> get props => [message];
}

final class ClinicFullLoading extends ClinicState {}

final class ClinicFullLoaded extends ClinicState {
  final Clinic clinic;
  const ClinicFullLoaded(this.clinic);

  @override
  List<Object> get props => [clinic];
}

final class ClinicFullError extends ClinicState {
  final Failure message;
  const ClinicFullError(this.message);

  @override
  List<Object> get props => [message];
}
