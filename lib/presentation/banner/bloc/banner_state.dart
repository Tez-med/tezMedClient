part of 'banner_bloc.dart';

sealed class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object> get props => [];
}

final class BannerInitial extends BannerState {}

final class BannerLoading extends BannerState {}

final class BannerLoaded extends BannerState {
  final BannerModel data;
  const BannerLoaded(this.data);
}

final class BannerError extends BannerState {
  final Failure error;
  const BannerError(this.error);
}
