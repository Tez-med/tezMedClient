import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/my_address/model/location_model.dart';
import 'package:tez_med_client/domain/my_address/usecase/get_my_address_usecase.dart';

part 'my_address_event.dart';
part 'my_address_state.dart';

class MyAddressBloc extends Bloc<MyAddressEvent, MyAddressState> {
  final GetMyAddressUsecase getMyAddressUsecase;
  MyAddressBloc(this.getMyAddressUsecase) : super(MyAddressInitial()) {
    on<FetchMyAddress>(_onFetchMyAddress);
  }

  Future<void> _onFetchMyAddress(
      FetchMyAddress event, Emitter<MyAddressState> emit) async {
    emit(MyAddressLoading());
    final result = await getMyAddressUsecase.getMyAddress();
    result.fold(
      (error) => emit(MyAddressError(error)),
      (data) => emit(MyAddressLoaded(data)),
    );
  }
}
