import 'dart:convert';
import 'package:http/http.dart' as http;

import '../interfaces/auth_interface.dart';
import '../models/user/login/login_request.dart';
import '../models/user/login/login_response.dart';

class AuthService implements IAuthService {

  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept':
              'application/json', // Vital para que Laravel devuelva JSON y no HTML
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // Deserializamos el JSON de Laravel usando nuestro DTO
        final jsonBody = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonBody);
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        // 401: Unauthorized (Credenciales malas) | 422: Unprocessable Entity (Validación fallida)
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Credenciales incorrectas');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      // Capturamos problemas de red (ej. XAMPP apagado)
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<void> logout(String token) async {
    final url = Uri.parse('$_baseUrl/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Inyectamos el token de Sanctum
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Fallo al cerrar sesión en el servidor');
      }
    } catch (e) {
      throw Exception('Error de red al cerrar sesión: $e');
    }
  }
}
