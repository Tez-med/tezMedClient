import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/promocode/model/promocode_model.dart';
import 'package:tez_med_client/domain/promocode/repositories/promocode_repositories.dart';

class PromocodeUsecase {
  final PromocodeRepositories promocodeRepositories;
  PromocodeUsecase(this.promocodeRepositories);

  Future<Either<Failure, PromocodeModel>> getPromocode(String key) async {
    return await promocodeRepositories.getPromocode(key);
  }
}
