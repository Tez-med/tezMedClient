import 'dart:convert';

RequestModel requestModelFromJson(String str) =>
    RequestModel.fromJson(json.decode(str));

String requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
  final String address;
  final String apartment;
  final String clientId;
  final String comment;
  final String createdAt;
  final String entrance;
  final String floor;
  final String house;
  final String latitude;
  final bool singleRequest;
  final String longitude;
  final String nurseTypeId;
  final ClientBody clientBody;
  final List<String> photos;
  final String accessCode;
  final int price;
  final String promocodeKey;
  final List<RequestAffairPost> requestAffairs;

  RequestModel({
    required this.address,
    required this.apartment,
    required this.clientId,
    required this.comment,
    required this.accessCode,
    required this.singleRequest,
    required this.createdAt,
    required this.entrance,
    required this.clientBody,
    required this.floor,
    required this.nurseTypeId,
    required this.promocodeKey,
    required this.house,
    required this.latitude,
    required this.longitude,
    required this.photos,
    required this.price,
    required this.requestAffairs,
  });

  RequestModel copyWith({
    String? address,
    String? apartment,
    String? clientId,
    String? comment,
    String? createdAt,
    String? entrance,
    String? floor,
    String? house,
    String? latitude,
    String? longitude,
    List<String>? photos,
    String? nurseTypeId,
    int? price,
    List<RequestAffairPost>? requestAffairs,
    ClientBody? clientBody,
    String? accessCode,
    String? promocodeKey,
    bool? singleRequest,
  }) =>
      RequestModel(
        address: address ?? this.address,
        promocodeKey: promocodeKey ?? this.promocodeKey,
        apartment: apartment ?? this.apartment,
        clientId: clientId ?? this.clientId,
        comment: comment ?? this.comment,
        createdAt: createdAt ?? this.createdAt,
        entrance: entrance ?? this.entrance,
        floor: floor ?? this.floor,
        nurseTypeId: nurseTypeId ?? this.nurseTypeId,
        house: house ?? this.house,
        clientBody: clientBody ?? this.clientBody,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        photos: photos ?? this.photos,
        accessCode: accessCode ?? this.accessCode,
        price: price ?? this.price,
        singleRequest: singleRequest ?? this.singleRequest,
        requestAffairs: requestAffairs ?? this.requestAffairs,
      );

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        address: json["address"],
        apartment: json["apartment"],
        clientId: json["client_id"],
        promocodeKey: json['promocode_key'],
        accessCode: json['access_code'],
        comment: json["comment"],
        singleRequest: json['single_request'],
        nurseTypeId: json['nurse_type_id'],
        clientBody: ClientBody.fromJson(json['client_body']),
        createdAt: json["created_at"],
        entrance: json["entrance"],
        floor: json["floor"],
        house: json["house"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        photos: List<String>.from(json["photos"].map((x) => x)),
        price: json["price"],
        requestAffairs: List<RequestAffairPost>.from(
            json["request_affairs"].map((x) => RequestAffairPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "apartment": apartment,
        "client_id": clientId,
        "comment": comment,
        "created_at": createdAt,
        "entrance": entrance,
        "floor": floor,
        "house": house,
        "latitude": latitude,
        "longitude": longitude,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "price": price,
        "promocode_key": promocodeKey,
        "nurse_type_id": nurseTypeId,
        "access_code": accessCode,
        "single_request": singleRequest,
        "client_body": clientBody.toJson(),
        "request_affairs":
            List<dynamic>.from(requestAffairs.map((x) => x.toJson())),
      };
}

class ClientBody {
  final String extraPhone;
  ClientBody({required this.extraPhone});

  factory ClientBody.fromJson(Map<String, dynamic> json) =>
      ClientBody(extraPhone: json['extra_phone']);

  Map<String, dynamic> toJson() => {"extra_phone": extraPhone};
}

class RequestAffairPost {
  final String affairId;
  final int count;
  final int day;
  final String startDate;

  RequestAffairPost({
    required this.affairId,
    required this.count,
    required this.day,
    required this.startDate,
  });

  factory RequestAffairPost.fromJson(Map<String, dynamic> json) {
    return RequestAffairPost(
      affairId: json['affair_id'] as String,
      count: json['count'] as int,
      day: json['day'] as int,
      startDate: json['start_date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'affair_id': affairId,
      'count': count,
      'day': day,
      'start_date': startDate,
    };
  }
}
