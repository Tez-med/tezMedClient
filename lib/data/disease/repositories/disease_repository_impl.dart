import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/disease/model/disease_model.dart';
import 'package:tez_med_client/data/disease/source/disease_source.dart';
import 'package:tez_med_client/domain/disease/repositories/disease_repository.dart';

class DiseaseRepositoryImpl implements DiseaseRepository {
  final DiseaseSource diseaseSource;

  DiseaseRepositoryImpl({required this.diseaseSource});

  @override
  Future<Either<Failure, DiseaseModel>> getDiseases() async {
    return await diseaseSource.getDiseases();
  }
}
