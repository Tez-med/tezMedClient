part of 'schedule_get_id_bloc.dart';

sealed class ScheduleGetIdState extends Equatable {
  const ScheduleGetIdState();

  @override
  List<Object> get props => [];
}

final class ScheduleGetIdInitial extends ScheduleGetIdState {}

final class ScheduleGetIdLoading extends ScheduleGetIdState {}

final class ScheduleGetIdSuccess extends ScheduleGetIdState {
  final Schedule data;
  const ScheduleGetIdSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class ScheduleGetIdError extends ScheduleGetIdState {
  final Failure error;
  const ScheduleGetIdError(this.error);

  @override
  List<Object> get props => [error];
}
