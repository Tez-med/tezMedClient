import 'dart:convert';

DoctorModel doctorModelFromJson(String str) =>
    DoctorModel.fromJson(json.decode(str));

String doctorModelToJson(DoctorModel data) => json.encode(data.toJson());

class DoctorModel {
  final int count;
  final List<Doctor> doctors;

  DoctorModel({
    required this.count,
    required this.doctors,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        count: json["count"],
        doctors:
            List<Doctor>.from(json["Doctors"].map((x) => Doctor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "Doctors": List<dynamic>.from(doctors.map((x) => x.toJson())),
      };
}

class Doctor {
  final String id;
  final String districtId;
  final String regionId;
  final String countryId;
  final String speciesId;
  final String fullName;
  final String birthday;
  final String gender;
  final List<String> passportPhoto;
  final List<String> diplomaPhoto;
  final List<String> certificate;
  final List<String> medicalSheet;
  final List<String> selfEmployed;
  final String status;
  final int rating;
  final String phoneNumber;
  final String photo;
  final int experience;
  final double consultationTime;
  final int consultationPrice;
  final String createdAt;

  Doctor({
    required this.id,
    required this.districtId,
    required this.regionId,
    required this.countryId,
    required this.speciesId,
    required this.fullName,
    required this.birthday,
    required this.gender,
    required this.passportPhoto,
    required this.diplomaPhoto,
    required this.certificate,
    required this.medicalSheet,
    required this.selfEmployed,
    required this.status,
    required this.rating,
    required this.phoneNumber,
    required this.photo,
    required this.experience,
    required this.consultationTime,
    required this.consultationPrice,
    required this.createdAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"] ?? "",
        districtId: json["district_id"] ?? "",
        regionId: json["region_id"] ?? "",
        countryId: json["country_id"] ?? "",
        speciesId: json["species_id"] ?? "",
        fullName: json["full_name"] ?? "",
        birthday: json["birthday"] ?? "",
        gender: json["gender"] ?? "",
        passportPhoto: json["passport_photo"] != null
            ? List<String>.from(json["passport_photo"].map((x) => x))
            : [],
        diplomaPhoto: json["diploma_photo"] != null
            ? List<String>.from(json["diploma_photo"].map((x) => x))
            : [],
        certificate: json["certificate"] != null
            ? List<String>.from(json["certificate"].map((x) => x))
            : [],
        medicalSheet: json["medical_sheet"] != null
            ? List<String>.from(json["medical_sheet"].map((x) => x))
            : [],
        selfEmployed: json["self_employed"] != null
            ? List<String>.from(json["self_employed"].map((x) => x))
            : [],
        status: json["status"],
        rating: json["rating"],
        phoneNumber: json["phone_number"],
        photo: json["photo"],
        experience: json["experience"],
        consultationTime: json["consultation_time"]?.toDouble(),
        consultationPrice: json["consultation_price"],
        createdAt: json["created_at"],
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
        "passport_photo": List<dynamic>.from(passportPhoto.map((x) => x)),
        "diploma_photo": List<dynamic>.from(diplomaPhoto.map((x) => x)),
        "certificate": List<dynamic>.from(certificate.map((x) => x)),
        "medical_sheet": List<dynamic>.from(medicalSheet.map((x) => x)),
        "self_employed": List<dynamic>.from(selfEmployed.map((x) => x)),
        "status": status,
        "rating": rating,
        "phone_number": phoneNumber,
        "photo": photo,
        "experience": experience,
        "consultation_time": consultationTime,
        "consultation_price": consultationPrice,
        "created_at": createdAt,
      };
}
