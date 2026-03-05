import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/home/home_feed_response.dart';
import '../models/book/book_response.dart';
import '../utils/safe_json_decode.dart';
import 'storage_service.dart';

class HomeService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storage = StorageService();

  Future<List<Book>> getLatestBooks() async {
    final jsonBody = await _fetchHomeFeedJson();
    final rawList = _extractList(jsonBody['latest_books'] ?? jsonBody['books']);

    return rawList
            ?.whereType<Map<String, dynamic>>()
            .map(BookResponse.fromJson)
            .toList() ??
        const [];
  }

  Future<List<Meetup>> getMeetups({String? city}) async {
    final jsonBody = await _fetchHomeFeedJson(city: city);
    final rawList = _extractList(
      jsonBody['upcoming_meetups_in_city'] ??
          jsonBody['meetups'] ??
          jsonBody['events'],
    );

    return rawList
            ?.whereType<Map<String, dynamic>>()
            .map(Meetup.fromJson)
            .toList() ??
        const [];
  }

  Future<List<MeetupAttendance>> getUpcomingAppointments() async {
    final jsonBody = await _fetchHomeFeedJson();
    final rawList = _extractList(
      jsonBody['my_confirmed_appointments'] ??
          jsonBody['appointments'] ??
          jsonBody['my_appointments'],
    );

    return rawList
            ?.whereType<Map<String, dynamic>>()
            .map(MeetupAttendance.fromJson)
            .toList() ??
        const [];
  }

  Future<Map<String, dynamic>> _fetchHomeFeedJson({String? city}) async {
    final token = await _storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No authenticated user token found');
    }

    final queryParams = <String, String>{
      if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
    };

    final uri = Uri.parse(
      '$_baseUrl/home/feed',
    ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    debugPrint('JSON CRUDO DEL BACKEND: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final decodedBody = safeJsonDecode(response.body);

    if (decodedBody is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    final data = decodedBody['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }

    return decodedBody;
  }

  List<dynamic>? _extractList(dynamic value) {
    if (value is List) {
      return value;
    }

    if (value is Map<String, dynamic>) {
      final nestedData = value['data'];
      if (nestedData is List) {
        return nestedData;
      }
    }

    return null;
  }
}
