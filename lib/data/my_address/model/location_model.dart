import 'dart:convert';

List<LocationModel> locationModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  final String latitude;
  final String longitude;
  final String name;
  final String floor;
  final String apartment;
  final String entrance;
  final String house;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.floor,
    required this.apartment,
    required this.entrance,
    required this.house,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
        name: json["name"] ?? "",
        floor: json["floor"] ?? "",
        apartment: json["apartment"] ?? "",
        entrance: json["entrance"] ?? "",
        house: json["house"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "name": name,
        "floor": floor,
        "apartment": apartment,
        "entrance": entrance,
        "house": house,
      };
}
