class RegisterRequest {
  final String nombre;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? organizacion; // Opcional, tal y como diseñaste en la UI

  RegisterRequest({
    required this.nombre,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.organizacion,
  });

  /// Transforma nuestro objeto de Dart al JSON que Laravel entiende
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'nombre': nombre,
      'email': email,
      'password': password,
      // ATENCIÓN AQUÍ: Laravel exige estrictamente el snake_case para la confirmación
      'password_confirmation': passwordConfirmation, 
    };

    // Solo enviamos la organización si el usuario escribió algo
    if (organizacion != null && organizacion!.trim().isNotEmpty) {
      map['organizacion'] = organizacion;
    }

    return map;
  }
}