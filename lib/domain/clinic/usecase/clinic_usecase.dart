import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/domain/clinic/repositories/clinic_repositories.dart';

class ClinicUsecase {
  final ClinicRepositories clinicRepositories;
  ClinicUsecase(this.clinicRepositories);
  Future<Either<Failure, ClinicsModel>> getClinics() async {
    return await clinicRepositories.getClinics();
  }

  Future<Either<Failure, Clinic>> getFullClinics(String id) async {
    return await clinicRepositories.getFullClinics(id);
  }
}
