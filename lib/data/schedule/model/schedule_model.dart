import 'dart:convert';

ScheduleModel scheduleModelFromJson(String str) => ScheduleModel.fromJson(json.decode(str));

String scheduleModelToJson(ScheduleModel data) => json.encode(data.toJson());

class ScheduleModel {
    final int count;
    final List<Schedule> schedules;

    ScheduleModel({
        required this.count,
        required this.schedules,
    });

    factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        count: json["count"] ?? 0,
        schedules: json["schedules"] != null ? List<Schedule>.from(json["schedules"].map((x) => Schedule.fromJson(x))) : [],
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
    final int doctorRating;
    final String doctorPhoto;
    final String clientId;
    final String doctorAffairsId;
    final int price;
    final String status;
    final String date;
    final String time;
    final String photo;
    final String createdAt;
    final String updatedAt;

    Schedule({
        required this.id,
        required this.doctorId,
        required this.doctorName,
        required this.doctorRating,
        required this.doctorPhoto,
        required this.clientId,
        required this.doctorAffairsId,
        required this.price,
        required this.status,
        required this.date,
        required this.time,
        required this.photo,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"] ?? "",
        doctorId: json["doctor_id"] ?? "",
        doctorName: json["doctor_name"] ?? "",
        doctorRating: json["doctor_rating"] ?? "",
        doctorPhoto: json["doctor_photo"] ?? "",
        clientId: json["client_id"] ?? "",
        doctorAffairsId: json["doctor_affairs_id"] ?? "",
        price: json["price"] ?? "",
        status: json["status"] ?? "",
        date: json["date"] ?? "",
        time: json["time"] ?? "",
        photo: json["photo"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "doctor_rating": doctorRating,
        "doctor_photo": doctorPhoto,
        "client_id": clientId,
        "doctor_affairs_id": doctorAffairsId,
        "price": price,
        "status": status,
        "date": date,
        "time": time,
        "photo": photo,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
