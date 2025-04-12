
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/disease/model/disease_model.dart';
import 'package:tez_med_client/domain/disease/entitiy/disease_entity.dart';

abstract class DiseaseRepository {
  Future<Either<Failure, DiseaseModel>> getDiseases();
  Future<Either<Failure,void>> createDisease(DiseasePost disease);

}