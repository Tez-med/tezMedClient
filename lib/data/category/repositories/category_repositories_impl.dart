import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/data/category/source/category_source.dart';
import 'package:tez_med_client/domain/category/repository/category_repositories.dart';

class CategoryRepositoriesImpl implements CategoryRepositories {
  final CategorySource categorySource;
  CategoryRepositoriesImpl(this.categorySource);
  @override
  Future<Either<Failure, List<CategoryModel>>> getCategory({String? districtId}) async {
    return await categorySource.getCategory(districtId: districtId);
  }
}
