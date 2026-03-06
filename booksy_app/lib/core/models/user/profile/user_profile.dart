class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? status;
  final int booksCount;
  final int eventsCount;
  final int exchangesCount;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.status,
    this.booksCount = 0,
    this.eventsCount = 0,
    this.exchangesCount = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final statsSource = _resolveStatsSource(json);

    return UserProfile(
      id: _toInt(json['id']),
      name: _toString(json['name'] ?? json['nombre'], fallback: 'Usuario'),
      email: _toString(json['email'], fallback: 'sin-email@booksy.app'),
      role: _toNullableString(json['role']),
      status: _toNullableString(json['status']),
      booksCount: _toInt(
        statsSource['books_count'] ?? statsSource['booksCount'],
      ),
      eventsCount: _toInt(
        statsSource['events_count'] ??
            statsSource['eventsCount'] ??
            statsSource['meetups_count'],
      ),
      exchangesCount: _toInt(
        statsSource['exchanges_count'] ??
            statsSource['exchangesCount'] ??
            statsSource['transactions_count'],
      ),
    );
  }

  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? status,
    int? booksCount,
    int? eventsCount,
    int? exchangesCount,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      booksCount: booksCount ?? this.booksCount,
      eventsCount: eventsCount ?? this.eventsCount,
      exchangesCount: exchangesCount ?? this.exchangesCount,
    );
  }
}

Map<String, dynamic> _resolveStatsSource(Map<String, dynamic> json) {
  final stats = json['stats'];
  if (stats is Map<String, dynamic>) {
    return stats;
  }

  final data = json['data'];
  if (data is Map<String, dynamic>) {
    final nestedStats = data['stats'];
    if (nestedStats is Map<String, dynamic>) {
      return nestedStats;
    }
    return data;
  }

  return json;
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
