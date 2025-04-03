import 'dart:convert';

BasicDoctorModel basicDoctorModelFromJson(String str) =>
    BasicDoctorModel.fromJson(json.decode(str));

String basicDoctorModelToJson(BasicDoctorModel data) =>
    json.encode(data.toJson());

class BasicDoctorModel {
  final String id;
  final String districtId;
  final String regionId;
  final String countryId;
  final String speciesId;
  final String fullName;
  final String birthday;
  final String gender;
  final String status;
  final int rating;
  final String phoneNumber;
  final String photo;
  final int experience;
  final double consultationTime;
  final int consultationPrice;
  final List<Schedule> schedules;

  BasicDoctorModel({
    required this.id,
    required this.districtId,
    required this.regionId,
    required this.countryId,
    required this.speciesId,
    required this.fullName,
    required this.birthday,
    required this.gender,
    required this.status,
    required this.rating,
    required this.phoneNumber,
    required this.photo,
    required this.experience,
    required this.consultationTime,
    required this.consultationPrice,
    required this.schedules,
  });

  factory BasicDoctorModel.fromJson(Map<String, dynamic> json) =>
      BasicDoctorModel(
        id: json["id"],
        districtId: json["district_id"],
        regionId: json["region_id"],
        countryId: json["country_id"],
        speciesId: json["species_id"],
        fullName: json["full_name"],
        birthday: json["birthday"],
        gender: json["gender"],
        status: json["status"],
        rating: json["rating"],
        phoneNumber: json["phone_number"],
        photo: json["photo"],
        experience: json["experience"],
        consultationTime: json["consultation_time"]?.toDouble(),
        consultationPrice: json["consultation_price"],
        schedules: List<Schedule>.from(
            json["schedules"].map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "district_id": districtId,
        "region_id": regionId,
        "country_id": countryId,
        "species_id": speciesId,
        "full_name": fullName,
        "birthday": birthday,
        "gender": gender,
        "status": status,
        "rating": rating,
        "phone_number": phoneNumber,
        "photo": photo,
        "experience": experience,
        "consultation_time": consultationTime,
        "consultation_price": consultationPrice,
        "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
      };
}

class Schedule {
  final String id;
  final String doctorId;
  final String clientId;
  final String doctorAffairsId;
  final int price;
  final String status;
  final String date;
  final String nurseTypeName;
  final String time;
  final String photo;

  Schedule({
    required this.id,
    required this.doctorId,
    required this.clientId,
    required this.doctorAffairsId,
    required this.price,
    required this.status,
    required this.date,
    required this.nurseTypeName,
    required this.time,
    required this.photo,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        doctorId: json["doctor_id"],
        clientId: json["client_id"],
        doctorAffairsId: json["doctor_affairs_id"],
        price: json["price"],
        status: json["status"],
        date: json["date"],
        nurseTypeName: json["nurse_type_name"],
        time: json["time"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_id": doctorId,
        "client_id": clientId,
        "doctor_affairs_id": doctorAffairsId,
        "price": price,
        "status": status,
        "date": date,
        "nurse_type_name": nurseTypeName,
        "time": time,
        "photo": photo,
      };
}
