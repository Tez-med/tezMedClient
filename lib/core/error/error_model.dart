class ErrorModel {
  final int errorcode;
  final String errormessage;

  ErrorModel({required this.errorcode, required this.errormessage});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      errorcode: json['error_code'] ?? 0,
      errormessage: json['error_message'] ?? 'Unknown error',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorcode': errorcode,
      'errormessage': errormessage,
    };
  }
}
