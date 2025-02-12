import 'package:dio/dio.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/comments/model/comment_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import 'dart:developer' as developer;
import '../../../core/error/error_handler.dart';

abstract class CommentSource {
  Future<Either<Failure, void>> postComment(CommentModel commentModel);
}

class CommentSourceImpl implements CommentSource {
  final DioClientRepository dioClientRepository;
  CommentSourceImpl(this.dioClientRepository);

  @override
  Future<Either<Failure, void>> postComment(CommentModel commentModel) async {
    final token = LocalStorageService().getString(StorageKeys.accestoken);
    developer.log(commentModel.toJson().toString());
    try {
      await dioClientRepository.postData("/comments/", commentModel.toJson(),
          token: token);
      return Right(null);
    } on DioException catch (e) {
      developer.log(e.toString());
      return Left(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure(code: 40));
    }
  }
}
