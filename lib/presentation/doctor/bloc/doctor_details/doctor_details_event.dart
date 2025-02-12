part of 'doctor_details_bloc.dart';

sealed class DoctorDetailsEvent extends Equatable {
  const DoctorDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetIdDoctor extends DoctorDetailsEvent {
  final String id;

  const GetIdDoctor(this.id);
}
