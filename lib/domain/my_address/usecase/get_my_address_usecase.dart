import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/my_address/model/location_model.dart';
import 'package:tez_med_client/domain/my_address/repositories/my_address_repositories.dart';

class GetMyAddressUsecase {
  final MyAddressRepositories myAddressRepositories;

  GetMyAddressUsecase(this.myAddressRepositories);

  Future<Either<Failure, List<LocationModel>>> getMyAddress() async {
    return await myAddressRepositories.getMyAddress();
  }
}
