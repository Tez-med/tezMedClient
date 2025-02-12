import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/promocode/model/promocode_model.dart';
import 'package:tez_med_client/data/promocode/source/promocode_source.dart';
import 'package:tez_med_client/domain/promocode/repositories/promocode_repositories.dart';

class PromocodeRepositoriesImpl implements PromocodeRepositories {
  final PromocodeSource promocodeSource;
  PromocodeRepositoriesImpl(this.promocodeSource);

  @override
  Future<Either<Failure, PromocodeModel>> getPromocode(String key) async {
    return await promocodeSource.getPromocode(key);
  }
}
