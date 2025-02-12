import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  final List<Banner> banners;
  final int count;

  BannerModel({
    required this.banners,
    required this.count,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        banners: json["banners"] != null
            ? List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x)))
            : [],
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
        "count": count,
      };
}

class Banner {
  final String id;
  final String photo;

  Banner({
    required this.id,
    required this.photo,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        id: json["id"] ?? "",
        photo: json["photo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
      };
}
