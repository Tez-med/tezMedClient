import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/doctor/model/basic_doctor_model.dart';
import 'package:tez_med_client/data/doctor/model/doctor_model.dart';
import 'package:tez_med_client/data/doctor/model/doctor_request_model.dart';
import 'package:tez_med_client/data/doctor/source/doctor_source.dart';
import 'package:tez_med_client/domain/doctor/repositories/doctor_repositories.dart';

class DoctorRepositoriesImpl implements DoctorRepositories {
  final DoctorSource doctorSource;
  DoctorRepositoriesImpl(this.doctorSource);

  @override
  Future<Either<Failure, DoctorModel>> getDoctor(String id) async {
    return await doctorSource.getDoctor(id);
  }

  @override
  Future<Either<Failure, BasicDoctorModel>> getIdDoctor(String id) async {
    return await doctorSource.getIdDoctor(id);
  }

  @override
  Future<Either<Failure, void>> doctorRequest(
      DoctorRequestModel request, String id) async {
    return await doctorSource.doctorRequest(request, id);
  }
}
