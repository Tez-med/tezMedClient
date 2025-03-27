import 'dart:convert';

ScheduleModel schedulesFromJson(String str) =>
    ScheduleModel.fromJson(json.decode(str));

String schedulesToJson(ScheduleModel data) => json.encode(data.toJson());

class ScheduleModel {
  final int count;
  final List<Schedule> schedules;

  ScheduleModel({
    required this.count,
    required this.schedules,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        count: json["count"] ?? 0,
        schedules: json["schedules"] != null
            ? List<Schedule>.from(
                json["schedules"].map((x) => Schedule.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
      };
}

class Schedule {
  final String id;
  final String doctorId;
  final String doctorName;
  final String clientName;
  final int doctorRating;
  final String doctorPhoto;
  final String clientId;
  final String doctorAffairsId;
  final int price;
  final String nurseTypeName;
  final String status;
  final String date;
  final String time;
  final String photo;
  final String roomId;
  final Meet meet;
  final String createdAt;

  Schedule({
    required this.id,
    required this.doctorId,
    required this.clientName,
    required this.doctorName,
    required this.doctorRating,
    required this.doctorPhoto,
    required this.clientId,
    required this.doctorAffairsId,
    required this.price,
    required this.nurseTypeName,
    required this.status,
    required this.date,
    required this.time,
    required this.photo,
    required this.roomId,
    required this.meet,
    required this.createdAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"] ?? "",
        doctorId: json["doctor_id"] ?? "",
        clientName: json['client_name'] ?? "",
        nurseTypeName: json['nurse_type_name'] ?? "",
        doctorName: json["doctor_name"] ?? "",
        doctorRating: json["doctor_rating"] ?? 0,
        doctorPhoto: json["doctor_photo"] ?? "",
        clientId: json["client_id"] ?? "",
        doctorAffairsId: json["doctor_affairs_id"] ?? "",
        price: json["price"] ?? 0,
        status: json["status"] ?? "",
        date: json["date"] ?? "",
        time: json["time"] ?? "",
        photo: json["photo"] ?? "",
        roomId: json["room_id"] ?? "",
        meet: Meet.fromJson(json["meet"]),
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_id": doctorId,
        "nurse_type_name": nurseTypeName,
        "doctor_name": doctorName,
        "doctor_rating": doctorRating,
        "doctor_photo": doctorPhoto,
        "client_id": clientId,
        "doctor_affairs_id": doctorAffairsId,
        "price": price,
        "status": status,
        "date": date,
        'client_name': clientName,
        "time": time,
        "photo": photo,
        "room_id": roomId,
        "meet": meet.toJson(),
        "created_at": createdAt,
      };
}

class Meet {
  final bool status;
  final String msg;
  final String url;

  Meet({
    required this.msg,
    required this.url,
    required this.status,
  });

  factory Meet.fromJson(Map<String, dynamic> json) => Meet(
        status: json["status"] ?? "",
        msg: json['msg'] ?? "",
        url: json['url'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "url": url,
      };
}
