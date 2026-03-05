import 'package:http/http.dart' as http;

import '../models/home/home_feed_response.dart';
import '../utils/safe_json_decode.dart';
import 'storage_service.dart';

class MeetupService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storage = StorageService();

  Future<List<Meetup>> getMeetups() async {
    final url = Uri.parse('$_baseUrl/meetups');
    final token = await _resolveToken();

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cargar eventos: ${response.statusCode}');
    }

    final decoded = safeJsonDecode(response.body);
    final List<dynamic> jsonList = decoded is Map && decoded.containsKey('data')
        ? decoded['data']
        : decoded;
    Set<int> joinedMeetupIds = <int>{};

    try {
      joinedMeetupIds = await getJoinedMeetupIds();
    } catch (_) {}

    return jsonList.whereType<Map<String, dynamic>>().map((json) {
      final meetup = Meetup.fromJson(json);
      return meetup.copyWith(
        isJoined: meetup.isJoined || joinedMeetupIds.contains(meetup.id),
      );
    }).toList();
  }

  Future<void> joinMeetup(int meetupId) async {
    final token = await _resolveToken();
    final url = Uri.parse('$_baseUrl/meetups/$meetupId/attendances');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(_extractErrorMessage(response));
    }
  }

  Future<Set<int>> getJoinedMeetupIds() async {
    final token = await _resolveToken();
    final url = Uri.parse('$_baseUrl/home/feed');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar citas del usuario: ${response.statusCode}',
      );
    }

    final decoded = safeJsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return <int>{};
    }

    final data = decoded['data'];
    final body = data is Map<String, dynamic> ? data : decoded;
    final appointments = body['my_confirmed_appointments'];

    if (appointments is! List) {
      return <int>{};
    }

    final meetupIds = <int>{};

    for (final item in appointments.whereType<Map<String, dynamic>>()) {
      final directMeetupId = _toIntOrNull(item['meetup_id']);
      if (directMeetupId != null) {
        meetupIds.add(directMeetupId);
        continue;
      }

      final meetup = item['meetup'];
      if (meetup is Map<String, dynamic>) {
        final nestedMeetupId = _toIntOrNull(meetup['id']);
        if (nestedMeetupId != null) {
          meetupIds.add(nestedMeetupId);
        }
      }
    }

    return meetupIds;
  }

  Future<String> _resolveToken() async {
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authenticated user token found');
    }
    return token;
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final decoded = safeJsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
    } catch (_) {}

    return 'Error al apuntarse al evento: ${response.statusCode}';
  }

  int? _toIntOrNull(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }
}
