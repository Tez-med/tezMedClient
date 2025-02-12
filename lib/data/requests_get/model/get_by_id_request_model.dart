import 'dart:convert';
import 'active_request_model.dart';

GetByIdRequestModel getByIdRequestModelFromJson(String str) =>
    GetByIdRequestModel.fromJson(json.decode(str));

String getByIdRequestModelToJson(GetByIdRequestModel data) =>
    json.encode(data.toJson());

class GetByIdRequestModel {
  final String id;
  final String clientId;
  final Client client;
  final String nurseId;
  final String nurseName;
  final int number;
  final int price;
  final String accessCode;
  final String longitude;
  final String latitude;
  final String startTime;
  final String address;
  final int promocodeAmount;
  final String house;
  final String floor;
  final String apartment;
  final String entrance;
  final List<String> photos;
  final List<RequestAffairGet> requestAffairs;
  final String status;
  final String comment;
  final String createdAt;
  final String updatedAt;

  GetByIdRequestModel({
    required this.id,
    required this.clientId,
    required this.client,
    required this.nurseId,
    required this.nurseName,
    required this.accessCode,
    required this.number,
    required this.price,
    required this.longitude,
    required this.promocodeAmount,
    required this.latitude,
    required this.startTime,
    required this.address,
    required this.house,
    required this.floor,
    required this.apartment,
    required this.entrance,
    required this.photos,
    required this.requestAffairs,
    required this.status,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetByIdRequestModel.fromJson(Map<String, dynamic> json) =>
      GetByIdRequestModel(
        id: json["id"] ?? "",
        clientId: json["client_id"] ?? "",
        client: Client.fromJson(json["client"]),
        nurseId: json["nurse_id"] ?? "",
        nurseName: json["nurse_name"] ?? "",
        promocodeAmount: json['promocode_amount'] ?? 0,
        number: json["number"] ?? "",
        accessCode: json['access_code'] ?? "",
        price: json["price"] ?? "",
        longitude: json["longitude"] ?? "",
        latitude: json["latitude"] ?? "",
        startTime: json["start_time"] ?? "",
        address: json["address"] ?? "",
        house: json["house"] ?? "",
        floor: json["floor"] ?? "",
        apartment: json["apartment"] ?? "",
        entrance: json["entrance"] ?? "",
        photos: json["photos"] != null
            ? List<String>.from(json["photos"].map((x) => x))
            : [],
        requestAffairs: List<RequestAffairGet>.from(
            json["request_affairs"].map((x) => RequestAffairGet.fromJson(x))),
        status: json["status"] ?? "",
        comment: json["comment"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "client": client.toJson(),
        "nurse_id": nurseId,
        "nurse_name": nurseName,
        "number": number,
        "price": price,
        "longitude": longitude,
        "latitude": latitude,
        "start_time": startTime,
        'access_code': accessCode,
        'promocode_amount':promocodeAmount,
        "address": address,
        "house": house,
        "floor": floor,
        "apartment": apartment,
        "entrance": entrance,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "request_affairs":
            List<dynamic>.from(requestAffairs.map((x) => x.toJson())),
        "status": status,
        "comment": comment,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Client {
  final String id;
  final String fullName;
  final String longitude;
  final String latitude;
  final String phoneNumber;
  final String gender;
  final String birthday;
  final String photo;
  final String createdAt;
  final String updatedAt;

  Client({
    required this.id,
    required this.fullName,
    required this.longitude,
    required this.latitude,
    required this.phoneNumber,
    required this.gender,
    required this.birthday,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"] ?? "",
        fullName: json["full_name"] ?? "",
        longitude: json["longitude"] ?? "",
        latitude: json["latitude"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        gender: json["gender"] ?? "",
        birthday: json["birthday"] ?? "",
        photo: json["photo"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "longitude": longitude,
        "latitude": latitude,
        "phone_number": phoneNumber,
        "gender": gender,
        "birthday": birthday,
        "photo": photo,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
