import 'dart:convert';

ClientResponseModel clientResponseModelFromJson(String str) =>
    ClientResponseModel.fromJson(json.decode(str));

String clientResponseModelToJson(ClientResponseModel data) =>
    json.encode(data.toJson());

class ClientResponseModel {
  final String id;
  final String fullName;
  final Location location;
  final Auth auth;

  ClientResponseModel({
    required this.id,
    required this.fullName,
    required this.location,
    required this.auth,
  });

  factory ClientResponseModel.fromJson(Map<String, dynamic> json) =>
      ClientResponseModel(
        id: json["id"] ?? "",
        fullName: json["full_name"] ?? "",
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : Location(longitude: "", latitude: ""),
        auth: json["auth"] != null
            ? Auth.fromJson(json["auth"])
            : Auth(accessToken: "", refreshToken: ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "location": location.toJson(),
        "auth": auth.toJson(),
      };
}

class Auth {
  final String accessToken;
  final String refreshToken;

  Auth({
    required this.accessToken,
    required this.refreshToken,
  });

  Auth copyWith({
    String? accessToken,
    String? refreshToken,
  }) =>
      Auth(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        accessToken: json["access_token"] ?? "",
        refreshToken: json["refresh_token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}

class Location {
  final String longitude;
  final String latitude;

  Location({
    required this.longitude,
    required this.latitude,
  });

  Location copyWith({
    String? longitude,
    String? latitude,
  }) =>
      Location(
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        longitude: json["longitude"] ?? "",
        latitude: json["latitude"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };
}
