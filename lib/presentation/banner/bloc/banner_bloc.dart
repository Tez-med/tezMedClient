import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/banner/model/banner_model.dart';
import 'package:tez_med_client/data/banner/source/get_banner_source.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final GetBannerSource getBannerSource;

  BannerBloc(this.getBannerSource) : super(BannerInitial()) {
    on<GetBanner>(_onGetBanner);
  }

  Future<void> _onGetBanner(GetBanner event, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    final result = await getBannerSource.getBanners();

    result.fold(
      (error) => emit(BannerError(error)),
      (data) => emit(BannerLoaded(data)),
    );
  }
}
