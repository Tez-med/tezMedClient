import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/schedule/model/schedule_model.dart';
import 'package:tez_med_client/domain/schedule/repositories/schedule_repositories.dart';

class ScheduleUsecase {
  final ScheduleRepositories scheduleRepositories;

  ScheduleUsecase(this.scheduleRepositories);

  Future<Either<Failure, ScheduleModel>> getSchedule(String id) async {
    return await scheduleRepositories.getSchedule(id);
  }

  Future<Either<Failure, Schedule>> getById(String id) =>
      scheduleRepositories.getById(id);
}
