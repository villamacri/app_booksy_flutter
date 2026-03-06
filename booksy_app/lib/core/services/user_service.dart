import 'package:booksy_app/core/models/user/profile/profile_stats.dart';
import 'package:http/http.dart' as http;

import '../utils/safe_json_decode.dart';
import 'storage_service.dart';

class UserService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  final StorageService _storage = StorageService();

  Future<ProfileStats> getProfileStats() async {
    final token = await _resolveToken();

    final responses = await Future.wait([
      http.get(
        Uri.parse('$_baseUrl/user/stats'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      http.get(
        Uri.parse('$_baseUrl/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    ]);

    for (final response in responses) {
      if (response.statusCode == 200) {
        final decoded = safeJsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return ProfileStats.fromJson(decoded);
        }
      }
    }

    throw Exception('No se pudieron cargar las estadísticas del perfil');
  }

  Future<String> _resolveToken() async {
    final token = await _storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No authenticated user token found');
    }

    return token;
  }
}
