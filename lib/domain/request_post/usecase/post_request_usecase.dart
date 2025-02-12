import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/domain/request_post/repositories/request_repositories.dart';

class PostRequestUsecase {
  final RequestRepositories repositories;
  PostRequestUsecase(this.repositories);
  Future<Either<Failure, void>> postRequest(RequestModel request) async {
    return await repositories.postRequest(request);
  }
}
