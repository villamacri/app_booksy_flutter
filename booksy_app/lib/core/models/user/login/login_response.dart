class LoginResponse {
  final String token;
  final String tokenType;
  final String message;
  final Map<String, dynamic> user;

  LoginResponse({
    required this.token,
    required this.tokenType,
    required this.message,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      message: json['message'] ?? '',
      user: json['user'] ?? {},
    );
  }

  String get bearerToken => '$tokenType $token';
}