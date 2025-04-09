import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/domain/category/repository/category_repositories.dart';

class GetCategoryUsecase {
  final CategoryRepositories categoryRepositories;
  GetCategoryUsecase(this.categoryRepositories);

  Future<Either<Failure, List<CategoryModel>>> getCategory({String? districtId}) async {
    return await categoryRepositories.getCategory(districtId: districtId);
  }
}
