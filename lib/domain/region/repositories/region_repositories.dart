import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/region/model/country_model.dart';
import 'package:tez_med_client/data/region/model/region_model.dart';

abstract class RegionRepositories {
  Future<Either<Failure, RegionModel>> getRegion(String countryId);
  Future<Either<Failure, CountryModel>> getCountry();
}
