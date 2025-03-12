part of 'schedule_get_id_bloc.dart';

sealed class ScheduleGetIdEvent extends Equatable {
  const ScheduleGetIdEvent();

  @override
  List<Object> get props => [];
}

class GetScheduleId extends ScheduleGetIdEvent {
  final String id;

  const GetScheduleId(this.id);

  @override
  List<Object> get props => [id];
}
