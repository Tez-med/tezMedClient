import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/species/model/species_model.dart';
import 'package:tez_med_client/domain/species/repositories/species_repositories.dart';

class GetSpeciesUsecase {
  final SpeciesRepositories speciesRepositories;
  GetSpeciesUsecase(this.speciesRepositories);

  Future<Either<Failure, SpeciesModel>> getSpecies(String id) async {
    return await speciesRepositories.getSpecies(id);
  }

  Future<Either<Failure, Speciess>> getByIdSpecies(String id) async {
    return await speciesRepositories.getByIdSpecies(id);
  }
}
