part of 'promocode_bloc.dart';

sealed class PromocodeEvent extends Equatable {
  const PromocodeEvent();

  @override
  List<Object> get props => [];
}

class PromocodeUsing extends PromocodeEvent {
  final String key;
  const PromocodeUsing(this.key);

  @override
  List<Object> get props => [key];
}
