import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/species/model/species_model.dart';

abstract class SpeciesRepositories {
  Future<Either<Failure, SpeciesModel>> getSpecies();
  Future<Either<Failure, Speciess>> getByIdSpecies(String id);
}
