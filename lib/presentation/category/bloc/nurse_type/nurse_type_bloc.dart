import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/species/model/nurse_type.dart';
import 'package:tez_med_client/data/species/source/get_nurse_type_source.dart';

part 'nurse_type_event.dart';
part 'nurse_type_state.dart';

class NurseTypeBloc extends Bloc<NurseTypeEvent, NurseTypeState> {
  final GetNurseTypeSource getNurseTypeSource;

  NurseTypeBloc(this.getNurseTypeSource) : super(NurseTypeInitial()) {
    on<GetType>(_onGetType);
  }

  Future<void> _onGetType(GetType event, Emitter<NurseTypeState> emit) async {
    emit(NurseTypeLoading());
    final result = await getNurseTypeSource.getType();

    result.fold(
      (error) => emit(NurseTypeError(error)),
      (data) => emit(NurseTypeLoaded(data)),
    );
  }
}
