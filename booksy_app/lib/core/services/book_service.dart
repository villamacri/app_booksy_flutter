import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/book/book_response.dart';
import 'storage_service.dart';

class BookService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storage = StorageService();

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
        final decodedBody = jsonDecode(response.body);

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
}
