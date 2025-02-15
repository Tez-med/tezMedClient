import 'dart:convert';

ClientModel clientModelFromJson(String str) =>
    ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
  final String id;
  final String districtId;
  final String regionId;
  final String countryId;
  final String districtName;
  final String fullName;
  final String longitude;
  final String latitude;
  final String phoneNumber;
  final String gender;
  final String birthday;
  final String photo;
  final String extraPhone;
  final int rating;
  final String fcmToken;
  final String createdAt;
  final String updatedAt;

  ClientModel({
    required this.id,
    required this.districtId,
    required this.regionId,
    required this.countryId,
    required this.districtName,
    required this.fullName,
    required this.longitude,
    required this.latitude,
    required this.phoneNumber,
    required this.gender,
    required this.birthday,
    required this.photo,
    required this.extraPhone,
    required this.rating,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"] ?? "",
        districtId: json["district_id"] ?? "",
        regionId: json["region_id"] ?? "",
        countryId: json["country_id"] ?? "",
        districtName: json["district_name"] ?? "",
        fullName: json["full_name"] ?? "",
        longitude: json["longitude"] ?? "",
        latitude: json["latitude"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        gender: json["gender"] ?? "",
        birthday: json["birthday"] ?? "",
        photo: json["photo"] ?? "",
        extraPhone: json["extra_phone"] ?? "",
        rating: json["rating"] ?? 0,
        fcmToken: json["fcm_token"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "district_id": districtId,
        "region_id": regionId,
        "country_id": countryId,
        "district_name": districtName,
        "full_name": fullName,
        "longitude": longitude,
        "latitude": latitude,
        "phone_number": phoneNumber,
        "gender": gender,
        "birthday": birthday,
        "photo": photo,
        "extra_phone": extraPhone,
        "rating": rating,
        "fcm_token": fcmToken,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
