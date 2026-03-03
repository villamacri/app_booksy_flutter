import 'dart:convert';
import 'package:http/http.dart' as http;

import '../interfaces/auth_interface.dart';
import '../models/user/login/login_request.dart';
import '../models/user/login/login_response.dart';
import '../models/user/register/register_request.dart';

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
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonBody);
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Credenciales incorrectas');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<LoginResponse> register(RegisterRequest request) async {
    final url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonBody); 
        
      } else if (response.statusCode == 422) {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? 'Error de validación en los datos';
        throw Exception(errorMessage);
        
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al registrar: $e');
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
          'Authorization': 'Bearer $token',
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