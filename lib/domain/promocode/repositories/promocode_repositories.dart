import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/promocode/model/promocode_model.dart';

abstract class PromocodeRepositories {
  Future<Either<Failure, PromocodeModel>> getPromocode(String key);
}
