import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/data/clinic/source/clinic_source.dart';
import 'package:tez_med_client/domain/clinic/repositories/clinic_repositories.dart';

class ClinicRepositoriesImpl implements ClinicRepositories {
  final ClinicSource clinicSource;
  ClinicRepositoriesImpl(this.clinicSource);

  @override
  Future<Either<Failure, ClinicsModel>> getClinics() async {
    return await clinicSource.getClinics();
  }

  @override
  Future<Either<Failure, Clinic>> getFullClinics(String id) async {
    return await clinicSource.getFullClinics(id);
  }
}
