class ProfileStats {
  final int booksCount;
  final int eventsCount;
  final int exchangesCount;

  const ProfileStats({
    this.booksCount = 0,
    this.eventsCount = 0,
    this.exchangesCount = 0,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    final source = _resolveSource(json);

    return ProfileStats(
      booksCount: _toInt(
        source['books_count'] ?? source['booksCount'] ?? source['libros_count'],
      ),
      eventsCount: _toInt(
        source['events_count'] ??
            source['eventsCount'] ??
            source['meetups_count'] ??
            source['eventos_count'],
      ),
      exchangesCount: _toInt(
        source['exchanges_count'] ??
            source['exchangesCount'] ??
            source['transactions_count'] ??
            source['intercambios_count'],
      ),
    );
  }

  static Map<String, dynamic> _resolveSource(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final stats = data['stats'];
      if (stats is Map<String, dynamic>) {
        return stats;
      }
      return data;
    }

    final stats = json['stats'];
    if (stats is Map<String, dynamic>) {
      return stats;
    }

    return json;
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
