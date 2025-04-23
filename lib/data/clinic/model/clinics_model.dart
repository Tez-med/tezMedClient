import 'dart:convert';

class ClinicsModel {
  final List<Clinic> clinics;

  ClinicsModel({
    required this.clinics,
  });

  factory ClinicsModel.fromJson(Map<String, dynamic> json) => ClinicsModel(
        clinics: json["clinics"] != null
            ? List<Clinic>.from(json["clinics"].map((x) => Clinic.fromJson(x)))
            : [],
      );
  Map<String, dynamic> toJson() => {
        "clinics": List<dynamic>.from(clinics.map((x) => x.toJson())),
      };
}

Clinic clinicFromJson(String str) => Clinic.fromJson(json.decode(str));

String clinicToJson(Clinic data) => json.encode(data.toJson());

class Clinic {
  final String id;
  final String districtId;
  final String regionId;
  final String countryId;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String longitude;
  final String latitude;
  final String description;
  final List<String> phoneNumber;
  final String address;
  final List<String> photo;
  final String instagramLink;
  final String tgLink;
  final int rating;
  final List<Hour> hours;
  final List<Amenity> amenities;

  Clinic({
    required this.id,
    required this.districtId,
    required this.regionId,
    required this.countryId,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.longitude,
    required this.latitude,
    required this.description,
    required this.phoneNumber,
    required this.address,
    required this.photo,
    required this.instagramLink,
    required this.tgLink,
    required this.rating,
    required this.hours,
    required this.amenities,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
        id: json["id"] ?? "",
        districtId: json["district_id"] ?? "",
        regionId: json["region_id"] ?? "",
        countryId: json["country_id"] ?? "",
        nameUz: json["name_uz"] ?? "",
        nameRu: json["name_ru"] ?? "",
        nameEn: json["name_en"] ?? "",
        longitude: json["longitude"] ?? "",
        latitude: json["latitude"] ?? "",
        description: json["description"] ?? "",
        phoneNumber: json["phone_number"] != null
            ? List<String>.from(json["phone_number"].map((x) => x))
            : [],
        address: json["address"] ?? "",
        photo: json["photo"] != null
            ? List<String>.from(json["photo"].map((x) => x))
            : [],
        instagramLink: json["instagram_link"] ?? "",
        tgLink: json["tg_link"] ?? "",
        rating: json["rating"] ?? 0,
        hours: json["hours"] != null
            ? List<Hour>.from(json["hours"].map((x) => Hour.fromJson(x)))
            : [],
        amenities: json["amenities"] != null
            ? List<Amenity>.from(
                json["amenities"].map((x) => Amenity.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "district_id": districtId,
        "region_id": regionId,
        "country_id": countryId,
        "name_uz": nameUz,
        "name_ru": nameRu,
        "name_en": nameEn,
        "longitude": longitude,
        "latitude": latitude,
        "description": description,
        "phone_number": List<dynamic>.from(phoneNumber.map((x) => x)),
        "address": address,
        "photo": List<dynamic>.from(photo.map((x) => x)),
        "instagram_link": instagramLink,
        "tg_link": tgLink,
        "rating": rating,
        "hours": List<dynamic>.from(hours.map((x) => x.toJson())),
        "amenities": List<dynamic>.from(amenities.map((x) => x.toJson())),
      };
}

class Amenity {
  final String id;
  final String clinicId;
  final String amenityId;
  final String nameUz;
  final String nameEn;
  final String nameRu;
  final String photo;

  Amenity({
    required this.id,
    required this.clinicId,
    required this.amenityId,
    required this.nameUz,
    required this.nameEn,
    required this.nameRu,
    required this.photo,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        id: json["id"] ?? "",
        clinicId: json["clinic_id"] ?? "",
        amenityId: json["amenity_id"] ?? "",
        nameUz: json["name_uz"] ?? "",
        nameEn: json["name_en"] ?? "",
        nameRu: json["name_ru"] ?? "",
        photo: json["photo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clinic_id": clinicId,
        "amenity_id": amenityId,
        "name_uz": nameUz,
        "name_en": nameEn,
        "name_ru": nameRu,
        "photo": photo,
      };
}

class Hour {
  final String id;
  final String clinicId;
  final int dayOfWeek;
  final String openHour;
  final String closeHours;
  final String createdAt;

  Hour({
    required this.id,
    required this.clinicId,
    required this.dayOfWeek,
    required this.openHour,
    required this.closeHours,
    required this.createdAt,
  });

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
        id: json["id"] ?? "",
        clinicId: json["clinic_id"] ?? "",
        dayOfWeek: json["day_of_week"] ?? 0,
        openHour: json["open_hour"] ?? "",
        closeHours: json["close_hours"] ?? "",
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clinic_id": clinicId,
        "day_of_week": dayOfWeek,
        "open_hour": openHour,
        "close_hours": closeHours,
        "created_at": createdAt,
      };
}
