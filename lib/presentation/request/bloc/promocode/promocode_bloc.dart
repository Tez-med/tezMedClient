import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/promocode/model/promocode_model.dart';
import 'package:tez_med_client/domain/promocode/usecase/promocode_usecase.dart';

part 'promocode_event.dart';
part 'promocode_state.dart';

class PromocodeBloc extends Bloc<PromocodeEvent, PromocodeState> {
  final PromocodeUsecase promocodeUsecase;

  PromocodeBloc(this.promocodeUsecase) : super(PromocodeInitial()) {
    on<PromocodeUsing>(_onPromocodeUsing);
  }

  Future<void> _onPromocodeUsing(
      PromocodeUsing event, Emitter<PromocodeState> emit) async {
    emit(PromocodeLoading());
    final result = await promocodeUsecase.getPromocode(event.key);

    result.fold(
      (error) => emit(PromocodeError(error)),
      (data) => emit(PromocodeLoaded(data)),
    );
  }
}
