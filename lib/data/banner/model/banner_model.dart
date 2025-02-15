import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  final List<Banner> banners;

  BannerModel({
    required this.banners,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        banners: json["banners"] != null
            ? List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
      };
}

class Banner {
  final String id;
  final String photoXlUz;
  final String photoLgUz;
  final String photoSmUz;
  final String photoXlRu;
  final String photoLgRu;
  final String photoSmRu;
  final String photoXlEn;
  final String photoLgEn;
  final String photoSmEn;
  final String createdAt;
  final String updatedAt;

  Banner({
    required this.id,
    required this.photoXlUz,
    required this.photoLgUz,
    required this.photoSmUz,
    required this.photoXlRu,
    required this.photoLgRu,
    required this.photoSmRu,
    required this.photoXlEn,
    required this.photoLgEn,
    required this.photoSmEn,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["id"] ?? "",
        photoXlUz: json["photo_xl_uz"] ?? "",
        photoLgUz: json["photo_lg_uz"] ?? "",
        photoSmUz: json["photo_sm_uz"] ?? "",
        photoXlRu: json["photo_xl_ru"] ?? "",
        photoLgRu: json["photo_lg_ru"] ?? "",
        photoSmRu: json["photo_sm_ru"] ?? "",
        photoXlEn: json["photo_xl_en"] ?? "",
        photoLgEn: json["photo_lg_en"] ?? "",
        photoSmEn: json["photo_sm_en"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo_xl_uz": photoXlUz,
        "photo_lg_uz": photoLgUz,
        "photo_sm_uz": photoSmUz,
        "photo_xl_ru": photoXlRu,
        "photo_lg_ru": photoLgRu,
        "photo_sm_ru": photoSmRu,
        "photo_xl_en": photoXlEn,
        "photo_lg_en": photoLgEn,
        "photo_sm_en": photoSmEn,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
