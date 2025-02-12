import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/region/model/country_model.dart';
import 'package:tez_med_client/data/region/model/region_model.dart';
import 'package:tez_med_client/data/region/source/region_source.dart';
import 'package:tez_med_client/domain/region/repositories/region_repositories.dart';

class RegionRepositoriesImpl implements RegionRepositories {
  final RegionSource regionSourcel;

  RegionRepositoriesImpl(this.regionSourcel);
  @override
  Future<Either<Failure, RegionModel>> getRegion(String countryId) async {
    return await regionSourcel.getRegion(countryId);
  }

  @override
  Future<Either<Failure, CountryModel>> getCountry() async {
    return await regionSourcel.getCountry();
  }

 
}
