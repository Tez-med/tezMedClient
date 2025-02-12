import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/doctor/model/basic_doctor_model.dart';
import 'package:tez_med_client/data/doctor/model/doctor_model.dart';
import 'package:tez_med_client/data/doctor/model/doctor_request_model.dart';

abstract class DoctorRepositories {
  Future<Either<Failure, DoctorModel>> getDoctor(String id);
  Future<Either<Failure, BasicDoctorModel>> getIdDoctor(String id);
  Future<Either<Failure, void>> doctorRequest(
      DoctorRequestModel request, String id);
}
