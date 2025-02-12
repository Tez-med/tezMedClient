part of 'my_address_bloc.dart';

sealed class MyAddressEvent extends Equatable {
  const MyAddressEvent();

  @override
  List<Object> get props => [];
}

final class FetchMyAddress extends MyAddressEvent {}
