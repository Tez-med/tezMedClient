import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/data/requests_get/source/finished_request_source.dart';
import 'package:tez_med_client/domain/requests_get/repositories/finished_request_repositories.dart';

class FinishedRequestRepositoriesImpl implements FinishedRequestRepositories {
  final FinishedRequestSource activeRequestSource;
  FinishedRequestRepositoriesImpl(this.activeRequestSource);
  @override
  Future<Either<Failure, ActiveRequest>> getFinishedRequest() async {
    return await activeRequestSource.getFinishedRequest();
  }
}
