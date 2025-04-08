
import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/disease/model/disease_model.dart';

abstract class DiseaseRepository {
  Future<Either<Failure, DiseaseModel>> getDiseases();
}