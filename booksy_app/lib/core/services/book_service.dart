import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/book/book_category.dart';
import '../models/book/book_response.dart';
import '../utils/safe_json_decode.dart';
import 'storage_service.dart';

class BookService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storage = StorageService();

  Future<List<BookCategory>> getCategories() async {
    final url = Uri.parse('$_baseUrl/categories');
    final token = await _storage.getToken();

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cargar categorias: ${response.statusCode}');
    }

    final decodedBody = safeJsonDecode(response.body);
    final List<dynamic> jsonList =
        decodedBody is Map && decodedBody.containsKey('data')
        ? decodedBody['data']
        : (decodedBody is List ? decodedBody : const []);

    return jsonList
        .whereType<Map<String, dynamic>>()
        .map(BookCategory.fromJson)
        .where((category) => category.id > 0)
        .toList();
  }

  Future<List<BookResponse>> getAllBooks() async {
    final url = Uri.parse('$_baseUrl/books');

    final token = await _storage.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = safeJsonDecode(response.body);

        final List<dynamic> jsonList =
            decodedBody is Map && decodedBody.containsKey('data')
            ? decodedBody['data']
            : decodedBody;

        return BookResponse.fromJsonList(jsonList);
      } else {
        throw Exception(
          'Error del servidor al cargar el catálogo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de red al obtener los libros: $e');
    }
  }

  Future<void> createBook(Map<String, dynamic> bookData) async {
    final url = Uri.parse('$_baseUrl/books');
    final token = await _storage.getToken();
    final payload = Map<String, dynamic>.from(bookData);

    if (payload.containsKey('condition') &&
        !payload.containsKey('physical_condition')) {
      payload['physical_condition'] = payload.remove('condition');
    }

    if (token == null || token.isEmpty) {
      throw Exception('No authenticated user token found');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // 🕵️‍♂️ Este print te dirá el problema exacto en la consola
        print('🔥 ERROR AL CREAR LIBRO: ${response.body}');

        String errorMessage = 'Error del servidor: ${response.statusCode}';

        try {
          final body = safeJsonDecode(response.body);
          if (body is Map<String, dynamic> && body['errors'] != null) {
            final Map<String, dynamic> errors = body['errors'];
            errorMessage = errors.values.first[0].toString();
          }
        } catch (_) {}

        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error de red al crear el libro: $e');
    }
  }
}
