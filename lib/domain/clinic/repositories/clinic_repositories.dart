import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';

abstract class ClinicRepositories {
  Future<Either<Failure, ClinicsModel>> getClinics();
  Future<Either<Failure, Clinic>> getFullClinics(String id);
}
