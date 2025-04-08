import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/disease/model/disease_model.dart';
import 'package:tez_med_client/domain/disease/usecase/get_diseases_usecase.dart';

part 'disease_event.dart';
part 'disease_state.dart';

class DiseaseBloc extends Bloc<DiseaseEvent, DiseaseState> {
  final GetDiseasesUseCase getDiseaseUsecase;
  DiseaseBloc(this.getDiseaseUsecase) : super(DiseaseInitial()) {
    on<FetchDiseases>(_onFetchDiseases);
  }

  Future<void> _onFetchDiseases(
      FetchDiseases event, Emitter<DiseaseState> emit) async {
    emit(DiseaseLoading());
    final result = await getDiseaseUsecase();
    result.fold(
      (error) => emit(DiseaseError(error)),
      (data) {
        if (data.diseasess.isEmpty) {
          emit(DiseaseEmpty());
        } else {
          emit(DiseaseLoaded(data.diseasess));
        }
      },
    );
  }
}
