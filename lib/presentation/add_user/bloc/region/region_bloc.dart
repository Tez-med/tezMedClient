import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/region/model/country_model.dart';
import 'package:tez_med_client/data/region/model/region_model.dart';
import 'package:tez_med_client/domain/region/usecase/get_region_usecase.dart';

part 'region_event.dart';
part 'region_state.dart';

class RegionBloc extends Bloc<RegionEvent, RegionState> {
  final GetRegionUsecase getRegionUsecase;

  RegionBloc(this.getRegionUsecase) : super(RegionInitial()) {
    on<FetchRegion>(_onFetchRegion);
    on<FetchCountry>(_onFetchCountry);
  }

  Future<void> _onFetchRegion(
      FetchRegion event, Emitter<RegionState> emit) async {
    emit(RegionLoading());
    final result = await getRegionUsecase.getRegion(event.countryId);
    result.fold(
      (error) => emit(RegionError(error)),
      (data) => emit(RegionLoaded(data)),
    );
  }



  Future<void> _onFetchCountry(
      FetchCountry event, Emitter<RegionState> emit) async {
    emit(RegionLoading());

    final result = await getRegionUsecase.getCountry();
    result.fold(
      (error) => emit(RegionError(error)),
      (data) => emit(CountryLoaded(data)),
    );
  }
}
