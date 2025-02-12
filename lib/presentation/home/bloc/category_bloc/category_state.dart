part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> category;
  const CategoryLoaded(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryError extends CategoryState {
  final Failure error;
  const CategoryError(this.error);

  @override
  List<Object> get props => [error];
}
