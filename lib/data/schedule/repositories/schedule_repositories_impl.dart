import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/schedule/model/schedule_model.dart';
import 'package:tez_med_client/data/schedule/source/schedule_source.dart';
import 'package:tez_med_client/domain/schedule/repositories/schedule_repositories.dart';

class ScheduleRepositoriesImpl implements ScheduleRepositories {
  final ScheduleSource scheduleSource;
  ScheduleRepositoriesImpl(this.scheduleSource);

  @override
  Future<Either<Failure, ScheduleModel>> getSchedule(String id) async {
    return await scheduleSource.getSchedule(id);
  }

  @override
  Future<Either<Failure, Schedule>> getById(String id) async {
    return await scheduleSource.getById(id);
  }
}
