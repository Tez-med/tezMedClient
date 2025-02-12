part of 'region_bloc.dart';

sealed class RegionState extends Equatable {
  const RegionState();

  @override
  List<Object> get props => [];
}

final class RegionInitial extends RegionState {}

final class RegionLoading extends RegionState {}

final class RegionLoaded extends RegionState {
  final RegionModel regionModel;

  const RegionLoaded(this.regionModel);
  @override
  List<Object> get props => [regionModel];
}

final class CountryLoaded extends RegionState {
  final CountryModel countryModel;

  const CountryLoaded(this.countryModel);
  @override
  List<Object> get props => [countryModel];
}

final class RegionError extends RegionState {
  final Failure error;
  const RegionError(this.error);
  @override
  List<Object> get props => [error];
}
