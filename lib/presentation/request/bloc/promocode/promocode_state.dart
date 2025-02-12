part of 'promocode_bloc.dart';

sealed class PromocodeState extends Equatable {
  const PromocodeState();

  @override
  List<Object> get props => [];
}

final class PromocodeInitial extends PromocodeState {}

final class PromocodeLoading extends PromocodeState {}

final class PromocodeLoaded extends PromocodeState {
  final PromocodeModel promocodeModel;
  const PromocodeLoaded(this.promocodeModel);

  @override
  List<Object> get props => [promocodeModel];
}

final class PromocodeError extends PromocodeState {
  final Failure error;
  const PromocodeError(this.error);
  @override
  List<Object> get props => [error];
}
