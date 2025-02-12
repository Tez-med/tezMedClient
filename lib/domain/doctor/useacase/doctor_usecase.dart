import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/doctor/model/basic_doctor_model.dart';
import 'package:tez_med_client/data/doctor/model/doctor_model.dart';
import 'package:tez_med_client/data/doctor/model/doctor_request_model.dart';
import 'package:tez_med_client/domain/doctor/repositories/doctor_repositories.dart';

class DoctorUsecase {
  final DoctorRepositories doctorRepositories;

  DoctorUsecase(this.doctorRepositories);

  Future<Either<Failure, DoctorModel>> getDoctor(String id) async {
    return doctorRepositories.getDoctor(id);
  }

  Future<Either<Failure, BasicDoctorModel>> getIdDoctor(String id) async {
    return doctorRepositories.getIdDoctor(id);
  }

  Future<Either<Failure, void>> doctorRequest(
      DoctorRequestModel request, String id) async {
    return await doctorRepositories.doctorRequest(request, id);
  }
}
