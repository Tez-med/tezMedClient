part of 'doctor_details_bloc.dart';

sealed class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object> get props => [];
}

final class DoctorDetailsInitial extends DoctorDetailsState {}

final class DoctorDetailsLoading extends DoctorDetailsState {}

final class DoctorDetailsLoaded extends DoctorDetailsState {
  final BasicDoctorModel data;
  const DoctorDetailsLoaded(this.data);
}

final class DoctorDetailsError extends DoctorDetailsState {
  final Failure error;
  const DoctorDetailsError(this.error);
}
