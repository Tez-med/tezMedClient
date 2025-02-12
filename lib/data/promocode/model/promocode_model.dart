import 'dart:convert';

PromocodeModel promocodeFromJson(String str) =>
    PromocodeModel.fromJson(json.decode(str));

String promocodeToJson(PromocodeModel data) => json.encode(data.toJson());

class PromocodeModel {
  final String id;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final int amount;
  final int percent;
  final int count;
  final String validDate;
  final String type;
  final String keyWord;
  final String createdAt;
  final String updatedAt;

  PromocodeModel({
    required this.id,
    required this.amount,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.percent,
    required this.count,
    required this.validDate,
    required this.type,
    required this.keyWord,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromocodeModel.fromJson(Map<String, dynamic> json) => PromocodeModel(
        id: json["id"] ?? "",
        nameUz: json["name_uz"] ?? "",
        nameRu: json["name_ru"] ?? "",
        amount: json['amount'] ??0,
        nameEn: json["name_en"] ?? "",
        percent: json["percent"] ?? 0,
        count: json["count"] ?? 0,
        validDate: json["valid_date"] ?? "",
        type: json["type"] ?? "",
        keyWord: json["key_word"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_uz": nameUz,
        "name_ru": nameRu,
        "name_en": nameEn,
        "percent": percent,
        "count": count,
        "amount": amount,
        "valid_date": validDate,
        "type": type,
        "key_word": keyWord,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
