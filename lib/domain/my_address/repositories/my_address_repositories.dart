import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/my_address/model/location_model.dart';

abstract class MyAddressRepositories {
  Future<Either<Failure, List<LocationModel>>> getMyAddress();
}
