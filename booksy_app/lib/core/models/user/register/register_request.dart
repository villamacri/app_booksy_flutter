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

  Map<String, dynamic> toJson() {
    // Dividir el nombre completo del formulario en nombre y apellido para Laravel
    final parts = nombre.trim().split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1
        ? parts.sublist(1).join(' ')
        : 'Sin apellido';

    final map = {
      'name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    // Solo enviamos la organización si no es nula/vacía y si existe en la BD
    if (organizacion != null && organizacion!.isNotEmpty) {
      map['organization'] = organizacion!;
    }

    return map;
  }
}
