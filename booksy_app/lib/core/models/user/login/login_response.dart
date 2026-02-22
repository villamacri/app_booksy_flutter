class LoginResponse {
  final String token;
  final String tokenType;
  final String message;
  // Guardamos el usuario como un Map genérico por ahora.
  // Más adelante lo mapearemos a un UserModel completo si es necesario.
  final Map<String, dynamic> user;

  LoginResponse({
    required this.token,
    required this.tokenType,
    required this.message,
    required this.user,
  });

  /// Factory method defensivo para deserializar el JSON que llega de Laravel
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      // Usamos el operador ?? (null-aware) para evitar pantallazos rojos si falta algún campo
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      message: json['message'] ?? '',
      user: json['user'] ?? {},
    );
  }

  /// Método de conveniencia para obtener el token formateado para futuras peticiones
  String get bearerToken => '$tokenType $token';
}