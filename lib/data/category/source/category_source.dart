import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import '../../../core/error/error_handler.dart';

abstract class CategorySource {
  Future<Either<Failure, List<CategoryModel>>> getCategory(
      {String? districtId});
}

class CategorySourceImpl implements CategorySource {
  final DioClientRepository dioClientRepository;

  CategorySourceImpl(this.dioClientRepository);

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategory(
      {String? districtId}) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      // URL ni district_id bor-yo'qligiga qarab shakllantiramiz
      final url = districtId != null
          ? "/category?district_id=$districtId"
          : "/category";

      final response = await dioClientRepository.getData(url, token: token);
      final List<CategoryModel> categories = List<CategoryModel>.from(
          response.data['Category'].map((x) => CategoryModel.fromJson(x)));

      return Right(categories);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
