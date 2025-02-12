part of 'nurse_type_bloc.dart';

sealed class NurseTypeEvent extends Equatable {
  const NurseTypeEvent();

  @override
  List<Object> get props => [];
}

class GetType extends NurseTypeEvent {}
