import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/data/requests_get/source/active_request_source.dart';
import 'package:tez_med_client/domain/requests_get/repositories/active_request_repositories.dart';

class ActiveRequestRepositoriesImpl implements ActiveRequestRepositories {
  final ActiveRequestSource activeRequestSource;
  ActiveRequestRepositoriesImpl(this.activeRequestSource);
  @override
  Future<Either<Failure, ActiveRequest>> getActiveRequest() async {
    return await activeRequestSource.getActiveRequest();
  }
}
