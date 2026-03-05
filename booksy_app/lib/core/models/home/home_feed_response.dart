import 'package:booksy_app/core/models/book/book_response.dart';

typedef Book = BookResponse;

class HomeFeedResponse {
  final List<Book> latestBooks;
  final List<Meetup> upcomingMeetups;
  final List<MeetupAttendance> myAppointments;

  const HomeFeedResponse({
    required this.latestBooks,
    required this.upcomingMeetups,
    required this.myAppointments,
  });

  factory HomeFeedResponse.fromJson(Map<String, dynamic> json) {
    final booksRaw = _extractList(
      json['latest_books'] ?? json['books'] ?? json['data'],
    );
    final meetupsRaw = _extractList(
      json['upcoming_meetups_in_city'] ?? json['meetups'] ?? json['events'],
    );
    final appointmentsRaw = _extractList(
      json['my_confirmed_appointments'] ??
          json['appointments'] ??
          json['my_appointments'],
    );

    return HomeFeedResponse(
      latestBooks:
          booksRaw
              ?.whereType<Map<String, dynamic>>()
              .map(BookResponse.fromJson)
              .toList() ??
          const [],
      upcomingMeetups:
          meetupsRaw
              ?.whereType<Map<String, dynamic>>()
              .map(Meetup.fromJson)
              .toList() ??
          const [],
      myAppointments:
          appointmentsRaw
              ?.whereType<Map<String, dynamic>>()
              .map(MeetupAttendance.fromJson)
              .toList() ??
          const [],
    );
  }
}

class Meetup {
  final int id;
  final String title;
  final String city;
  final DateTime? scheduledAt;
  final String? location;
  final String? description;
  final bool isJoined;

  DateTime? get dateTime => scheduledAt;

  const Meetup({
    required this.id,
    required this.title,
    required this.city,
    this.scheduledAt,
    this.location,
    this.description,
    this.isJoined = false,
  });

  factory Meetup.fromJson(Map<String, dynamic> json) {
    final rawDate = json['scheduled_at'] ?? json['meetup_date'] ?? json['date'];

    return Meetup(
      id: _toInt(json['id']),
      title: _toString(
        json['title'] ?? json['name'],
        fallback: 'Evento sin título',
      ),
      city: _toString(json['city']),
      scheduledAt: _toDateTime(rawDate),
      location: _toNullableString(json['location']),
      description: _toNullableString(json['description']),
      isJoined: _toBool(
        json['is_joined'] ?? json['joined'] ?? json['current_user_joined'],
      ),
    );
  }

  Meetup copyWith({
    int? id,
    String? title,
    String? city,
    DateTime? scheduledAt,
    String? location,
    String? description,
    bool? isJoined,
  }) {
    return Meetup(
      id: id ?? this.id,
      title: title ?? this.title,
      city: city ?? this.city,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      location: location ?? this.location,
      description: description ?? this.description,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}

class MeetupAttendance {
  final int id;
  final int meetupId;
  final String status;
  final Meetup? meetup;

  const MeetupAttendance({
    required this.id,
    required this.meetupId,
    required this.status,
    this.meetup,
  });

  factory MeetupAttendance.fromJson(Map<String, dynamic> json) {
    final meetupJson = json['meetup'];

    return MeetupAttendance(
      id: _toInt(json['id']),
      meetupId: _toInt(json['meetup_id']),
      status: _toString(json['status']),
      meetup: meetupJson is Map<String, dynamic>
          ? Meetup.fromJson(meetupJson)
          : null,
    );
  }
}

int _toInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  if (value is num) {
    return value.toInt();
  }
  return fallback;
}

String _toString(dynamic value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }
  if (value is String) {
    return value;
  }
  return value.toString();
}

String? _toNullableString(dynamic value) {
  if (value == null) {
    return null;
  }
  return _toString(value);
}

DateTime? _toDateTime(dynamic value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

bool _toBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is int) {
    return value == 1;
  }
  if (value is String) {
    return value.toLowerCase() == 'true' || value == '1';
  }
  return false;
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
