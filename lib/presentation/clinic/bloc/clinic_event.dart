part of 'clinic_bloc.dart';

sealed class ClinicEvent extends Equatable {
  const ClinicEvent();

  @override
  List<Object> get props => [];
}

class GetClinicsEvent extends ClinicEvent {
  final bool forceRefresh;

  const GetClinicsEvent({this.forceRefresh = false});

  @override
  List<Object> get props => [forceRefresh];
}

class GetFullClinicsEvent extends ClinicEvent {
  final String id;

  const GetFullClinicsEvent(this.id);

  @override
  List<Object> get props => [id];
}
