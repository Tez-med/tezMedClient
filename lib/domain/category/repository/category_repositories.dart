import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';

abstract class CategoryRepositories {
  Future<Either<Failure, List<CategoryModel>>> getCategory({String? districtId});
}
