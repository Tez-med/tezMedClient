import 'dart:convert';

PaymentHistoryModel paymentHistoryModelFromJson(String str) =>
    PaymentHistoryModel.fromJson(json.decode(str));

String paymentHistoryModelToJson(PaymentHistoryModel data) =>
    json.encode(data.toJson());

class PaymentHistoryModel {
  final int count;
  final List<Payment> payments;

  PaymentHistoryModel({
    required this.count,
    required this.payments,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryModel(
        count: json["count"] ?? "",
        payments: json["payments"] != null
            ? List<Payment>.from(
                json["payments"].map((x) => Payment.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
      };
}

class Payment {
  final String id;
  final String nurseId;
  final int price;
  final int number;
  final String type;
  final String status;
  final String createdAt;

  Payment({
    required this.id,
    required this.number,
    required this.nurseId,
    required this.price,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"] ?? "",
        nurseId: json["nurse_id"] ?? "",
        price: json["price"] ?? "",
        number: json['number'] ?? 0,
        type: json["type"] ?? "",
        status: json["status"] ?? "",
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nurse_id": nurseId,
        "price": price,
        'number': number,
        "type": type,
        "status": status,
        "created_at": createdAt,
      };
}
