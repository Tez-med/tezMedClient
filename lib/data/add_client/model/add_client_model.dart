import 'dart:convert';

AddClientModel addClientModelFromJson(String str) =>
    AddClientModel.fromJson(json.decode(str));

String addClientModelToJson(AddClientModel data) => json.encode(data.toJson());

class AddClientModel {
  final String birthday;
  final String createdAt;
  final String fullName;
  final String gender;
  final String latitude;
  final String longitude;
  final String phoneNumber;
  final String extraPhone;
  final String regionId;

  AddClientModel({
    required this.birthday,
    required this.regionId,
    required this.extraPhone,
    required this.createdAt,
    required this.fullName,
    required this.gender,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
  });

  factory AddClientModel.fromJson(Map<String, dynamic> json) => AddClientModel(
        birthday: json["birthday"],
        createdAt: json["created_at"],
        fullName: json["full_name"],
        regionId: json["district_id"],
        gender: json["gender"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        phoneNumber: json["phone_number"],
        extraPhone: json['extra_phone'],
      );

  Map<String, dynamic> toJson() => {
        "birthday": birthday,
        "created_at": createdAt,
        "district_id": regionId,
        "full_name": fullName,
        "gender": gender,
        'extra_phone': extraPhone,
        "latitude": latitude,
        "longitude": longitude,
        "phone_number": phoneNumber,
      };
}
