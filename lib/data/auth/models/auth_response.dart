class AuthResponse {
  final String phone;
  final bool userFound;
  final String id;
  final Auth auth;

  AuthResponse({
    required this.phone,
    required this.userFound,
    required this.id,
    required this.auth,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        phone: json["phone"],
        userFound: json["user_found"],
        auth: Auth.fromJson(json["auth"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'user_found': userFound,
      'id': id,
      'auth': auth.toJson(),
    };
  }

  // Add copyWith method
  AuthResponse copyWith({
    String? phone,
    bool? userFound,
    String? id,
    Auth? auth,
  }) {
    return AuthResponse(
      phone: phone ?? this.phone,
      userFound: userFound ?? this.userFound,
      id: id ?? this.id,
      auth: auth ?? this.auth,
    );
  }
}

class Auth {
  final String accessToken;

  final String refreshToken;

  Auth({
    required this.accessToken,
    required this.refreshToken,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  // Add copyWith method
  Auth copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return Auth(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
