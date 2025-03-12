import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/schedule/model/schedule_model.dart';

abstract class ScheduleRepositories {
  Future<Either<Failure, ScheduleModel>> getSchedule(String id);
  Future<Either<Failure,Schedule>> getById(String id);

}
