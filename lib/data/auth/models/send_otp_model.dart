
import 'package:tez_med_client/domain/auth/entity/send_otp_entity.dart';

class SendOtpModel extends SendOtpEntity {
  SendOtpModel({required super.phoneNumber, required super.appSignatureCode});

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel(
      phoneNumber: json['phone'] as String,
      appSignatureCode: json["encrypt_code"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": 0,
      "phone": phoneNumber,
      "encrypt_code": appSignatureCode,
    };
  }
}
