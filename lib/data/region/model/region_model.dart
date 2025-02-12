import 'dart:convert';

RegionModel regionModelFromJson(String str) =>
    RegionModel.fromJson(json.decode(str));

String regionModelToJson(RegionModel data) => json.encode(data.toJson());

class RegionModel {
  final int count;
  final List<Region> regions;

  RegionModel({
    required this.count,
    required this.regions,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
        count: json["count"] ?? "",
        regions: json["regions"] != null
            ? List<Region>.from(json["regions"].map((x) => Region.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "regions": List<dynamic>.from(regions.map((x) => x.toJson())),
      };
}

class Region {
  final String id;
  final String countryId;
  final String regionId;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String createdAt;

  Region({
    required this.id,
    required this.countryId,
    required this.regionId,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.createdAt,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"] ?? "",
        countryId: json["country_id"] ?? "",
        regionId: json["region_id"] ?? "",
        nameUz: json["name_uz"] ?? "",
        nameRu: json["name_ru"] ?? "",
        nameEn: json["name_en"] ?? "",
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_id": countryId,
        "region_id": regionId,
        "name_uz": nameUz,
        "name_ru": nameRu,
        "name_en": nameEn,
        "created_at": createdAt,
      };
}
