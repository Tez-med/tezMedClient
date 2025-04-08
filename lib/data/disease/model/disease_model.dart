import 'dart:convert';

DiseaseModel diseaseModelFromJson(String str) =>
    DiseaseModel.fromJson(json.decode(str));

String diseaseModelToJson(DiseaseModel data) => json.encode(data.toJson());

class DiseaseModel {
  final int count;
  final List<Diseasess> diseasess;

  DiseaseModel({
    required this.count,
    required this.diseasess,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) => DiseaseModel(
        count: json["count"] ?? 0,
        diseasess: json["diseasess"] == null
            ? []
            : List<Diseasess>.from(
                json["diseasess"].map((x) => Diseasess.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "diseasess": List<dynamic>.from(diseasess.map((x) => x.toJson())),
      };
}

class Diseasess {
  final String id;
  final String clientId;
  final String scheduleId;
  final String name;
  final List<String> photo;
  final String description;
  final String status;
  final String createdAt;

  Diseasess({
    required this.id,
    required this.clientId,
    required this.scheduleId,
    required this.name,
    required this.photo,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory Diseasess.fromJson(Map<String, dynamic> json) => Diseasess(
        id: json["id"],
        clientId: json["client_id"],
        scheduleId: json["schedule_id"],
        name: json["name"],
        photo: List<String>.from(json["photo"].map((x) => x)),
        description: json["description"],
        status: json["status"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "schedule_id": scheduleId,
        "name": name,
        "photo": List<dynamic>.from(photo.map((x) => x)),
        "description": description,
        "status": status,
        "created_at": createdAt,
      };
}
