import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import '../../../core/error/error_handler.dart';

abstract class CategorySource {
  Future<Either<Failure, List<CategoryModel>>> getCategory();
}

class CategorySourceImpl implements CategorySource {
  final DioClientRepository dioClientRepository;
  CategorySourceImpl(this.dioClientRepository);
  @override
  Future<Either<Failure, List<CategoryModel>>> getCategory() async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    try {
      final response =
          await dioClientRepository.getData("/category", token: token);
      final List<CategoryModel> categories = (response.data['Category'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      return Right(categories);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
