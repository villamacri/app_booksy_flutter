import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../interfaces/auth_interface.dart';
import '../models/user/login/login_request.dart';
import '../models/user/login/login_response.dart';
import '../models/user/profile/user_profile.dart';
import '../models/user/register/register_request.dart';
import '../utils/safe_json_decode.dart';

import 'storage_service.dart';

class AuthService implements IAuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  final StorageService _storage = StorageService();

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
        final jsonBody = safeJsonDecode(response.body);

        await _storage.saveToken(jsonBody['token']);

        final role = jsonBody['user']['role'] ?? 'user';
        await _storage.saveRole(role);

        return LoginResponse.fromJson(jsonBody);
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        final errorBody = safeJsonDecode(response.body);
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
        final jsonBody = safeJsonDecode(response.body);

        await _storage.saveToken(jsonBody['token']);
        final role = jsonBody['user']['role'] ?? 'user';
        await _storage.saveRole(role);

        return LoginResponse.fromJson(jsonBody);
      } else {
        debugPrint('ERROR DEL BACKEND: ${response.body}');

        if (response.statusCode == 422) {
          final errorBody = safeJsonDecode(response.body);
          throw Exception(_extractValidationMessage(errorBody));
        }

        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Error de conexión al registrar: $e');
    }
  }

  String _extractValidationMessage(dynamic errorBody) {
    if (errorBody is! Map<String, dynamic>) {
      return 'Error de validación en los datos';
    }

    final errors = errorBody['errors'];
    if (errors is Map) {
      for (final fieldErrors in errors.values) {
        if (fieldErrors is List && fieldErrors.isNotEmpty) {
          final firstError = fieldErrors.first?.toString().trim();
          if (firstError != null && firstError.isNotEmpty) {
            return firstError;
          }
        }

        final singleError = fieldErrors?.toString().trim();
        if (singleError != null && singleError.isNotEmpty) {
          return singleError;
        }
      }
    }

    final message = errorBody['message']?.toString().trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }

    return 'Error de validación en los datos';
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final token = await _storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No authenticated user token found');
    }

    final url = Uri.parse('$_baseUrl/user');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = safeJsonDecode(response.body);

        if (jsonBody is! Map<String, dynamic>) {
          throw Exception('Respuesta de perfil inválida');
        }

        return UserProfile.fromJson(jsonBody);
      }

      throw Exception('Error del servidor: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error de red al obtener el perfil: $e');
    }
  }

  @override
  Future<void> logout() async {
    final token = await _storage.getToken();

    if (token == null || token.isEmpty) {
      await _storage.deleteToken();
      return;
    }

    final url = Uri.parse('$_baseUrl/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await _storage.deleteToken();
      } else {
        throw Exception('Fallo al cerrar sesión en el servidor');
      }
    } catch (e) {
      throw Exception('Error de red al cerrar sesión: $e');
    }
  }
}
