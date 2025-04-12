
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/disease/model/disease_model.dart';
import 'package:tez_med_client/domain/disease/entitiy/disease_entity.dart';
import 'package:tez_med_client/domain/disease/repositories/disease_repository.dart';

class GetDiseasesUseCase {
  final DiseaseRepository repository;

  GetDiseasesUseCase(this.repository);

  Future<Either<Failure, DiseaseModel>> call() async {
    return await repository.getDiseases();
  }

  Future<Either<Failure, void>> createDisease(DiseasePost disease) async {
    return await repository.createDisease(disease);
  }
}