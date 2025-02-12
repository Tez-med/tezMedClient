import 'dart:convert';

ProfileUpdateModel profileUpdateMdProfileUpdateModelFromJson(String str) =>
    ProfileUpdateModel.fromJson(json.decode(str));

String profileUpdateMdProfileUpdateModelToJson(ProfileUpdateModel data) =>
    json.encode(data.toJson());

class ProfileUpdateModel {
  final String birthday;
  final String fullName;
  final String gender;
  final String fcmToken;
  final String latitude;
  final String longitude;
  final String phoneNumber;
  final String photo;
  final String updatedAt;

  ProfileUpdateModel({
    required this.birthday,
    required this.fullName,
    required this.gender,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.photo,
    required this.fcmToken,
    required this.updatedAt,
  });

  ProfileUpdateModel copyWith({
    String? birthday,
    String? fullName,
    String? gender,
    String? latitude,
    String? longitude,
    String? phoneNumber,
    String? photo,
    String? updatedAt,
    String? fcmToken,
  }) =>
      ProfileUpdateModel(
        birthday: birthday ?? this.birthday,
        fullName: fullName ?? this.fullName,
        gender: gender ?? this.gender,
        fcmToken: fcmToken ?? this.fcmToken,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        photo: photo ?? this.photo,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateModel(
        birthday: json["birthday"] ?? "",
        fullName: json["full_name"] ?? "",
        fcmToken: json['fcm_token'] ?? "",
        gender: json["gender"] ?? "",
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        photo: json["photo"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "birthday": birthday,
        "full_name": fullName,
        "gender": gender,
        "latitude": latitude,
        "longitude": longitude,
        "fcm_token": fcmToken,
        "phone_number": phoneNumber,
        "photo": photo,
        "updated_at": updatedAt,
      };
}
