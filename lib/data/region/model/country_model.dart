import 'dart:convert';

CountryModel countryModelFromJson(String str) => CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
    final int count;
    final List<Country> countries;

    CountryModel({
        required this.count,
        required this.countries,
    });

    factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        count: json["count"] ?? "",
        countries: json["countries"] != null ? List<Country>.from(json["countries"].map((x) => Country.fromJson(x))) : [],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "countries": List<dynamic>.from(countries.map((x) => x.toJson())),
    };
}

class Country {
    final String id;
    final String nameUz;
    final String nameRu;
    final String nameEn;
    final String createdAt;

    Country({
        required this.id,
        required this.nameUz,
        required this.nameRu,
        required this.nameEn,
        required this.createdAt,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"] ?? "",
        nameUz: json["name_uz"] ?? "",
        nameRu: json["name_ru"] ?? "",
        nameEn: json["name_en"] ?? "",
        createdAt: json["created_at"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name_uz": nameUz,
        "name_ru": nameRu,
        "name_en": nameEn,
        "created_at": createdAt,
    };
}
