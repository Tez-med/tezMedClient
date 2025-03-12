import 'dart:convert';

NurseType nurseTypeFromJson(String str) => NurseType.fromJson(json.decode(str));

String nurseTypeToJson(NurseType data) => json.encode(data.toJson());

class NurseType {
    final int count;
    final List<Types> types;

    NurseType({
        required this.count,
        required this.types,
    });

    factory NurseType.fromJson(Map<String, dynamic> json) => NurseType(
        count: json["count"],
        types: List<Types>.from(json["types"].map((x) => Types.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "types": List<dynamic>.from(types.map((x) => x.toJson())),
    };
}

class Types {
    final String id;
    final String nameUz;
    final String nameEn;
    final String nameRu;
    final int price;
    final String type;
    final String createdAt;
    final String updatedAt;

    Types({
        required this.id,
        required this.nameUz,
        required this.nameEn,
        required this.nameRu,
        required this.price,
        required this.type,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Types.fromJson(Map<String, dynamic> json) => Types(
        id: json["id"] ?? "",
        nameUz: json["name_uz"] ?? "",
        nameEn: json["name_en"] ?? "",
        nameRu: json["name_ru"] ?? "",
        price: json["price"] ?? 0,
        type: json["type"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name_uz": nameUz,
        "name_en": nameEn,
        "name_ru": nameRu,
        "price": price,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
