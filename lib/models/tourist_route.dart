import 'package:cloud_firestore/cloud_firestore.dart';

class TouristRoute {
  const TouristRoute({
    required this.id,
    required this.userId,
    required this.city,
    required this.budget,
    required this.duration,
    required this.preferences,
    required this.experienceIds,
    required this.aiRoute,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String city;
  final double budget;
  final String duration;
  final String preferences;
  final List<String> experienceIds;
  final String aiRoute;
  final DateTime createdAt;

  factory TouristRoute.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};

    return TouristRoute(
      id: _readString(data['id']),
      userId: _readString(data['userId']),
      city: _readString(data['city']),
      budget: _readDouble(data['budget']),
      duration: _readString(data['duration']),
      preferences: _readString(data['preferences']),
      experienceIds: _readStringList(data['experienceIds']),
      aiRoute: _readString(data['aiRoute']),
      createdAt: _readDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'city': city,
      'budget': budget,
      'duration': duration,
      'preferences': preferences,
      'experienceIds': experienceIds,
      'aiRoute': aiRoute,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  TouristRoute copyWith({
    String? id,
    String? userId,
    String? city,
    double? budget,
    String? duration,
    String? preferences,
    List<String>? experienceIds,
    String? aiRoute,
    DateTime? createdAt,
  }) {
    return TouristRoute(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      city: city ?? this.city,
      budget: budget ?? this.budget,
      duration: duration ?? this.duration,
      preferences: preferences ?? this.preferences,
      experienceIds: experienceIds ?? this.experienceIds,
      aiRoute: aiRoute ?? this.aiRoute,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

String _readString(Object? value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }

  final text = value.toString().trim();
  return text.isEmpty ? fallback : text;
}

double _readDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    return double.tryParse(value) ?? 0;
  }

  return 0;
}

List<String> _readStringList(Object? value) {
  if (value is Iterable) {
    return value
        .where((item) => item != null)
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  return const [];
}

DateTime _readDateTime(Object? value) {
  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is DateTime) {
    return value;
  }

  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}
