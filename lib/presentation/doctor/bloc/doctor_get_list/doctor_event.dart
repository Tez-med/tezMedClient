part of 'doctor_bloc.dart';

sealed class DoctorEvent extends Equatable {
  const DoctorEvent();

  @override
  List<Object> get props => [];
}

class GetDoctor extends DoctorEvent {
  final String id;

  const GetDoctor(this.id);
}


