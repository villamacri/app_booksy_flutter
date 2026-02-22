class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  /// Convierte nuestra clase Dart en un mapa JSON para la petición HTTP POST
  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(), // Limpiamos espacios accidentales
      'password': password,
    };
  }
}
