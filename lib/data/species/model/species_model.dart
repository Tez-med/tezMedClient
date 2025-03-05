import 'dart:convert';

import 'package:tez_med_client/data/category/model/category_model.dart';

SpeciesModel speciesModelFromJson(String str) =>
    SpeciesModel.fromJson(json.decode(str));

String speciesModelToJson(SpeciesModel data) => json.encode(data.toJson());

class SpeciesModel {
  final num count;
  final List<Speciess> speciess;

  SpeciesModel({
    required this.count,
    required this.speciess,
  });

  factory SpeciesModel.fromJson(Map<String, dynamic> json) => SpeciesModel(
        count: json["count"] ?? "",
        speciess: json["Speciess"] != null
            ? List<Speciess>.from(
                json["Speciess"].map((x) => Speciess.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "Speciess": List<dynamic>.from(speciess.map((x) => x.toJson())),
      };
}

class Speciess {
  final String id;
  final String categoryId;
  final String categoryNameUz;
  final String categoryNameRu;
  final String categoryNameEn;
  final String nameEn;
  final String nameRu;
  final String nameUz;
  final bool isActive;
  final String photo;
  final String descriptionUz;
  final String descriptionRu;
  final String descriptionEn;
  final num orderNumber;
  final String type;
  final List<Department> departments;
  final List<DoctorBasic> doctors;
  final String createdAt;

  Speciess({
    required this.id,
    required this.categoryId,
    required this.categoryNameUz,
    required this.categoryNameRu,
    required this.categoryNameEn,
    required this.nameEn,
    required this.nameRu,
    required this.nameUz,
    required this.isActive,
    required this.photo,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.orderNumber,
    required this.type,
    required this.departments,
    required this.doctors,
    required this.createdAt,
  });

  factory Speciess.fromJson(Map<String, dynamic> json) => Speciess(
        id: json["id"] ?? "",
        categoryId: json["category_id"] ?? "",
        categoryNameUz: json["category_name_uz"] ?? "",
        categoryNameRu: json["category_name_ru"] ?? "",
        categoryNameEn: json["category_name_en"] ?? "",
        nameEn: json["name_en"] ?? "",
        nameRu: json["name_ru"] ?? "",
        nameUz: json["name_uz"] ?? "",
        isActive: json["is_active"] ?? false,
        photo: json["photo"] ?? "",
        descriptionUz: json["description_uz"] ?? "",
        descriptionRu: json["description_ru"] ?? "",
        descriptionEn: json["description_en"] ?? "",
        orderNumber: json["order_number"] ?? 0,
        type: json["type"] ?? "",
        departments: json["departments"] != null
            ? List<Department>.from(
                json["departments"].map((x) => Department.fromJson(x)))
            : [],
        doctors: json["doctors"] != null
            ? List<DoctorBasic>.from(
                json["doctors"].map((x) => DoctorBasic.fromJson(x)))
            : [],
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "category_name_uz": categoryNameUz,
        "category_name_ru": categoryNameRu,
        "category_name_en": categoryNameEn,
        "name_en": nameEn,
        "name_ru": nameRu,
        "name_uz": nameUz,
        "is_active": isActive,
        "photo": photo,
        "description_uz": descriptionUz,
        "description_ru": descriptionRu,
        "description_en": descriptionEn,
        "order_number": orderNumber,
        "type": type,
        "departments": departments,
        "doctors": doctors,
        "created_at": createdAt,
      };
}

class DoctorBasic {
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
  final num rating;
  final String phoneNumber;
  final String photo;
  final num experience;
  final num consultationTime;
  final num consultationPrice;
  final dynamic schedules;
  final List<DoctorAffair> doctorAffairs;
  final String createdAt;

  DoctorBasic({
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
    required this.schedules,
    required this.doctorAffairs,
    required this.createdAt,
  });

  factory DoctorBasic.fromJson(Map<String, dynamic> json) => DoctorBasic(
        id: json["id"] ?? "",
        districtId: json["district_id"] ?? "",
        regionId: json["region_id"] ?? "",
        countryId: json["country_id"] ?? "",
        speciesId: json["species_id"] ?? "",
        fullName: json["full_name"] ?? "",
        birthday: json["birthday"] ?? "",
        gender: json["gender"],
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
        status: json["status"] ?? "",
        rating: json["rating"] ?? 0,
        phoneNumber: json["phone_number"] ?? "",
        photo: json["photo"] ?? "",
        experience: json["experience"] ?? 0,
        consultationTime: json["consultation_time"] ?? 0, // Modified line
        consultationPrice: json["consultation_price"] ?? 0,
        schedules: json["schedules"] ?? "",
        doctorAffairs: json["doctor_affairs"] != null
            ? List<DoctorAffair>.from(
                json["doctor_affairs"].map((x) => DoctorAffair.fromJson(x)))
            : [],
        createdAt: json["created_at"] ?? "",
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
        "schedules": schedules,
        "doctor_affairs":
            List<dynamic>.from(doctorAffairs.map((x) => x.toJson())),
        "created_at": createdAt,
      };
}

class DoctorAffair {
  final String id;
  final String doctorId;
  final String nurseTypeId;
  final String days;
  final String startTime;
  final String endTime;
  final num price;
  final num consultationTime;
  final String createdAt;

  DoctorAffair({
    required this.id,
    required this.doctorId,
    required this.nurseTypeId,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.consultationTime,
    required this.createdAt,
  });

  factory DoctorAffair.fromJson(Map<String, dynamic> json) => DoctorAffair(
        id: json["id"] ?? "",
        doctorId: json["doctor_id"] ?? "",
        nurseTypeId: json["nurse_type_id"] ?? "",
        days: json["days"] ?? "",
        startTime: json["start_time"] ?? "",
        endTime: json["end_time"] ?? "",
        price: json["price"] ?? 0,
        consultationTime: json["consultation_time"] ?? 0.0,
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_id": doctorId,
        "nurse_type_id": nurseTypeId,
        "days": days,
        "start_time": startTime,
        "end_time": endTime,
        "price": price,
        "consultation_time": consultationTime,
        "created_at": createdAt,
      };
}
