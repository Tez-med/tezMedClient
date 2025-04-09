part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategory extends CategoryEvent {
  final String? districtId;

  const GetCategory({this.districtId});

  @override
  List<Object> get props => [districtId ?? '']; 
}
