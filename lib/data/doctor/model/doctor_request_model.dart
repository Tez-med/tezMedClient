import 'dart:convert';

DoctorRequestModel doctorRequestModelFromJson(String str) =>
    DoctorRequestModel.fromJson(json.decode(str));

String doctorRequestModelToJson(DoctorRequestModel data) =>
    json.encode(data.toJson());

class DoctorRequestModel {
  final String accessCode;
  final String address;
  final String apartment;
  final ClientBody clientBody;
  final String clientId;
  final String date;
  final String doctorAffairsId;
  final String doctorId;
  final String entrance;
  final String floor;
  final String house;
  final String latitude;
  final String longitude;
  final String photo;
  final int price;
  final String status;
  final String time;

  DoctorRequestModel({
    required this.accessCode,
    required this.address,
    required this.apartment,
    required this.clientBody,
    required this.clientId,
    required this.date,
    required this.doctorAffairsId,
    required this.doctorId,
    required this.entrance,
    required this.floor,
    required this.house,
    required this.latitude,
    required this.longitude,
    required this.photo,
    required this.price,
    required this.status,
    required this.time,
  });

  factory DoctorRequestModel.fromJson(Map<String, dynamic> json) =>
      DoctorRequestModel(
        accessCode: json["access_code"],
        address: json["address"],
        apartment: json["apartment"],
        clientBody: ClientBody.fromJson(json["client_body"]),
        clientId: json["client_id"],
        date: json["date"],
        doctorAffairsId: json["doctor_affairs_id"],
        doctorId: json["doctor_id"],
        entrance: json["entrance"],
        floor: json["floor"],
        house: json["house"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        photo: json["photo"],
        price: json["price"],
        status: json["status"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "access_code": accessCode,
        "address": address,
        "apartment": apartment,
        "client_body": clientBody.toJson(),
        "client_id": clientId,
        "date": date,
        "doctor_affairs_id": doctorAffairsId,
        "doctor_id": doctorId,
        "entrance": entrance,
        "floor": floor,
        "house": house,
        "latitude": latitude,
        "longitude": longitude,
        "photo": photo,
        "price": price,
        "status": status,
        "time": time,
      };
}

class ClientBody {
  final String birthday;
  final String createdAt;
  final String districtId;
  final String extraPhone;
  final String fullName;
  final String gender;
  final String latitude;
  final String longitude;
  final String phoneNumber;
  final String photo;

  ClientBody({
    required this.birthday,
    required this.createdAt,
    required this.districtId,
    required this.extraPhone,
    required this.fullName,
    required this.gender,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.photo,
  });

  factory ClientBody.fromJson(Map<String, dynamic> json) => ClientBody(
        birthday: json["birthday"],
        createdAt: json["created_at"],
        districtId: json["district_id"],
        extraPhone: json["extra_phone"],
        fullName: json["full_name"],
        gender: json["gender"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        phoneNumber: json["phone_number"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "birthday": birthday,
        "created_at": createdAt,
        "district_id": districtId,
        "extra_phone": extraPhone,
        "full_name": fullName,
        "gender": gender,
        "latitude": latitude,
        "longitude": longitude,
        "phone_number": phoneNumber,
        "photo": photo,
      };
}
