part of 'region_bloc.dart';

sealed class RegionEvent extends Equatable {
  const RegionEvent();

  @override
  List<Object> get props => [];
}

class FetchRegion extends RegionEvent {
  final String countryId;
  const FetchRegion(this.countryId);
  @override
  List<Object> get props => [countryId];
}

class FetchCountry extends RegionEvent {}
