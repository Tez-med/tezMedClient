part of 'nurse_type_bloc.dart';

sealed class NurseTypeState extends Equatable {
  const NurseTypeState();

  @override
  List<Object> get props => [];
}

final class NurseTypeInitial extends NurseTypeState {}

final class NurseTypeLoading extends NurseTypeState {}

final class NurseTypeLoaded extends NurseTypeState {
  final NurseType data;
  const NurseTypeLoaded(this.data);
}

final class NurseTypeError extends NurseTypeState {
  final Failure error;
  const NurseTypeError(this.error);
}
