import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/safe_json_decode.dart';
import 'storage_service.dart';

class TransactionService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  final StorageService _storage = StorageService();

  Future<void> createTransaction({
    required int bookId,
    required String type,
  }) async {
    final token = await _storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No authenticated user token found');
    }

    final url = Uri.parse('$_baseUrl/transactions');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'book_id': bookId,
        'transaction_type': type,
        'status': 'pending',
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('🔥 ERROR DE LARAVEL: ${response.body}');

      String errorMessage = 'Error: ${response.statusCode}';

      try {
        final body = safeJsonDecode(response.body);
        if (body is Map<String, dynamic>) {
          if (body['errors'] != null) {
            final Map<String, dynamic> errors = body['errors'];
            errorMessage = errors.values.first[0].toString();
          } else if (body['message'] != null) {
            errorMessage = body['message'].toString();
          }
        }
      } catch (_) {}

      throw Exception(errorMessage);
    }
  }
}
