part of 'my_address_bloc.dart';

sealed class MyAddressState extends Equatable {
  const MyAddressState();

  @override
  List<Object> get props => [];
}

final class MyAddressInitial extends MyAddressState {}

final class MyAddressLoading extends MyAddressState {}

final class MyAddressLoaded extends MyAddressState {
  final List<LocationModel> locationModel;

  const MyAddressLoaded(this.locationModel);

  @override
  List<Object> get props => [locationModel];
}
final class MyAddressError extends MyAddressState {
  final Failure error;

  const MyAddressError(this.error);

  @override
  List<Object> get props => [error];
}
