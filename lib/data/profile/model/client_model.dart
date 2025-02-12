import 'dart:convert';

ClientModel clientModelFromJson(String str) =>
    ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
  final String id;
  final String fullName;
  final String longitude;
  final String latitude;
  final String phoneNumber;
  final String gender;
  final String birthday;
  final String createdAt;
  final String photo;

  ClientModel({
    required this.id,
    required this.fullName,
    required this.longitude,
    required this.latitude,
    required this.photo,
    required this.phoneNumber,
    required this.gender,
    required this.birthday,
    required this.createdAt,
  });

  ClientModel copyWith({
    String? id,
    String? fullName,
    String? longitude,
    String? latitude,
    String? phoneNumber,
    String? gender,
    String? birthday,
    String? createdAt,
    String? photo,
  }) =>
      ClientModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        photo: photo ?? this.photo,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        gender: gender ?? this.gender,
        birthday: birthday ?? this.birthday,
        createdAt: createdAt ?? this.createdAt,
      );

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"] ?? "",
        fullName: json["full_name"] ?? "",
        longitude: json["longitude"] ?? "",
        latitude: json["latitude"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        gender: json["gender"] ?? "",
        birthday: json["birthday"] ?? "",
        photo: json['photo'] ?? "",
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "longitude": longitude,
        "latitude": latitude,
        "phone_number": phoneNumber,
        "gender": gender,
        "birthday": birthday,
        "photo" : photo,
        "created_at": createdAt,
      };
}
