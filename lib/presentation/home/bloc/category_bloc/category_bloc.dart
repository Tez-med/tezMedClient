import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/domain/category/usecase/get_category_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryUsecase getCategoryUsecase;

  CategoryBloc(this.getCategoryUsecase) : super(CategoryInitial()) {
    on<GetCategory>(_onGetCategory);
  }

  Future<void> _onGetCategory(
      GetCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await getCategoryUsecase.getCategory();
    result.fold(
      (error) => emit(CategoryError(error)),
      (data) => emit(CategoryLoaded(data)),
    );
  }
}
