import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/domain/requests_get/repositories/finished_request_repositories.dart';

class GetFinishedRequestUsecase {
  final FinishedRequestRepositories activeRequestRepositories;
  GetFinishedRequestUsecase(this.activeRequestRepositories);

  Future<Either<Failure, ActiveRequest>> getFinishedRequest() async {
    return await activeRequestRepositories.getFinishedRequest();
  }
}
