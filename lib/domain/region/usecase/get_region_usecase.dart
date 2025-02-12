import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/region/model/country_model.dart';
import 'package:tez_med_client/data/region/model/region_model.dart';
import 'package:tez_med_client/domain/region/repositories/region_repositories.dart';

class GetRegionUsecase {
  final RegionRepositories regionRepositories;

  GetRegionUsecase(this.regionRepositories);

  Future<Either<Failure, RegionModel>> getRegion(String countryId) async {
    return await regionRepositories.getRegion(countryId);
  }

  Future<Either<Failure, CountryModel>> getCountry() async {
    return await regionRepositories.getCountry();
  }
}
