import 'dart:convert';

import 'package:tez_med_client/data/category/model/category_model.dart';

ActiveRequest activeRequestFromJson(String str) =>
    ActiveRequest.fromJson(json.decode(str));

String activeRequestToJson(ActiveRequest data) => json.encode(data.toJson());

class ActiveRequest {
  final int count;
  final int totalPrice;
  final int average;
  final List<Requestss> requestss;

  ActiveRequest({
    required this.count,
    required this.totalPrice,
    required this.average,
    required this.requestss,
  });

  ActiveRequest copyWith({
    int? count,
    int? totalPrice,
    int? average,
    List<Requestss>? requestss,
  }) =>
      ActiveRequest(
        count: count ?? this.count,
        totalPrice: totalPrice ?? this.totalPrice,
        average: average ?? this.average,
        requestss: requestss ?? this.requestss,
      );

  factory ActiveRequest.fromJson(Map<String, dynamic> json) => ActiveRequest(
        count: json["count"] ?? "",
        totalPrice: json["total_price"] ?? "",
        average: json["average"] ?? "",
        requestss: json["requestss"] != null
            ? List<Requestss>.from(
                json["requestss"].map((x) => Requestss.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_price": totalPrice,
        "average": average,
        "requestss": List<dynamic>.from(requestss.map((x) => x.toJson())),
      };
}

class Requestss {
  final String id;
  final String clientId;
  final int number;
  final int price;
  final String longitude;
  final String latitude;
  final String startTime;
  final String address;
  final int nurseRating;
  final String house;
  final String floor;
  final String comment;
  final String apartment;
  final String entrance;
  final List<String> photos;
  final String nurseName;
  final String nursePhoto;
  final List<RequestAffairGet> requestAffairs;
  final String status;
  final String createdAt;

  Requestss({
    required this.id,
    required this.clientId,
    required this.number,
    required this.comment,
    required this.price,
    required this.longitude,
    required this.nurseRating,
    required this.latitude,
    required this.nursePhoto,
    required this.startTime,
    required this.address,
    required this.nurseName,
    required this.house,
    required this.floor,
    required this.apartment,
    required this.entrance,
    required this.photos,
    required this.requestAffairs,
    required this.status,
    required this.createdAt,
  });

  Requestss copyWith({
    String? id,
    String? clientId,
    int? number,
    int? price,
    String? longitude,
    String? latitude,
    String? startTime,
    String? address,
    String? house,
    String? floor,
    String? apartment,
    String? entrance,
    List<String>? photos,
    String? comment,
    String? nurseName,
    List<RequestAffairGet>? requestAffairs,
    String? status,
    String? createdAt,
    int? nurseRating,
    String? nursePhoto,
  }) =>
      Requestss(
        id: id ?? this.id,
        nursePhoto: nursePhoto ?? this.nursePhoto,
        clientId: clientId ?? this.clientId,
        number: number ?? this.number,
        comment: comment ?? this.comment,
        nurseRating: nurseRating ?? this.nurseRating,
        nurseName: nurseName ?? this.nurseName,
        price: price ?? this.price,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        startTime: startTime ?? this.startTime,
        address: address ?? this.address,
        house: house ?? this.house,
        floor: floor ?? this.floor,
        apartment: apartment ?? this.apartment,
        entrance: entrance ?? this.entrance,
        photos: photos ?? this.photos,
        requestAffairs: requestAffairs ?? this.requestAffairs,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Requestss.fromJson(Map<String, dynamic> json) => Requestss(
        id: json["id"] ?? "",
        clientId: json["client_id"] ?? "",
        number: json["number"] ?? "",
        price: json["price"] ?? "",
        longitude: json["longitude"] ?? "",
        nursePhoto: json['nurse_photo'] ?? "",
        latitude: json["latitude"] ?? "",
        startTime: json["start_time"] ?? "",
        address: json["address"] ?? "",
        nurseRating: json['nurse_rating'] ?? 0,
        nurseName: json['nurse_name'] ?? "",
        house: json["house"] ?? "",
        comment: json['comment'] ?? "",
        floor: json["floor"] ?? "",
        apartment: json["apartment"] ?? "",
        entrance: json["entrance"] ?? "",
        photos: json["photos"] != null
            ? List<String>.from(json["photos"].map((x) => x))
            : [],
        requestAffairs: List<RequestAffairGet>.from(
            json["request_affairs"].map((x) => RequestAffairGet.fromJson(x))),
        status: json["status"] ?? "",
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "number": number,
        "price": price,
        "longitude": longitude,
        "latitude": latitude,
        "start_time": startTime,
        "address": address,
        "house": house,
        "floor": floor,
        "apartment": apartment,
        'nurse_rating' : nurseRating,
        "entrance": entrance,
        "nurse_name": nurseName,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "request_affairs":
            List<dynamic>.from(requestAffairs.map((x) => x.toJson())),
        "status": status,
        "created_at": createdAt,
      };
}

class RequestAffairGet {
  final String affairId;
  final int count;
  final String createdAt;
  final String nameUz;
  final String nameEn;
  final String nameRu;
  final TypeModel typeModel;
  final String startDate;
  final int price;
  final String hour;

  RequestAffairGet({
    required this.startDate,
    required this.affairId,
    required this.hour,
    required this.count,
    required this.createdAt,
    required this.nameUz,
    required this.nameEn,
    required this.nameRu,
    required this.typeModel,
    required this.price,
  });

  factory RequestAffairGet.fromJson(Map<String, dynamic> json) =>
      RequestAffairGet(
        affairId: json["affair_id"] ?? "",
        count: json["count"] ?? 0,
        hour: json['hour'] ?? "",
        startDate: json['start_date'] ?? "",
        createdAt: json["created_at"] ?? "",
        nameUz: json["name_uz"] ?? "",
        nameEn: json["name_en"] ?? "",
        nameRu: json["name_ru"] ?? "",
        typeModel: TypeModel.fromJson(json['nurse_type_data'] ?? {}),
        price: json["price"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "affair_id": affairId,
        "count": count,
        "hour": hour,
        "nurse_type_data": typeModel.toJson(),
        "created_at": createdAt,
        "name_uz": nameUz,
        "start_date": startDate,
        "name_en": nameEn,
        "name_ru": nameRu,
        "price": price,
      };

  RequestAffairGet copyWith({
    String? affairId,
    int? count,
    String? createdAt,
    String? nameUz,
    String? nameEn,
    String? nameRu,
    TypeModel? typeModel,
    String? startDate,
    int? price,
    String? hour,
  }) {
    return RequestAffairGet(
      affairId: affairId ?? this.affairId,
      count: count ?? this.count,
      hour: hour ?? this.hour,
      createdAt: createdAt ?? this.createdAt,
      nameUz: nameUz ?? this.nameUz,
      nameEn: nameEn ?? this.nameEn,
      nameRu: nameRu ?? this.nameRu,
      typeModel: typeModel ?? this.typeModel,
      startDate: startDate ?? this.startDate,
      price: price ?? this.price,
    );
  }
}
