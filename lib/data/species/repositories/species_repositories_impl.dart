import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/species/model/species_model.dart';
import 'package:tez_med_client/data/species/source/species_source.dart';
import 'package:tez_med_client/domain/species/repositories/species_repositories.dart';

class SpeciesRepositoriesImpl implements SpeciesRepositories {
  final SpeciesSource speciesSource;

  SpeciesRepositoriesImpl(this.speciesSource);
  @override
  Future<Either<Failure, SpeciesModel>> getSpecies() async {
    return await speciesSource.getSpecies();
  }

  @override
  Future<Either<Failure, Speciess>> getByIdSpecies(String id,[String? district]) async {
    return await speciesSource.getByIdSpecies(id);
  }
}
