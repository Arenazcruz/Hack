import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.city,
    required this.createdAt,
  });

  final String uid;
  final String name;
  final String email;
  final String role;
  final String city;
  final DateTime createdAt;

  factory UserProfile.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};

    return UserProfile(
      uid: _readString(data['uid']),
      name: _readString(data['name']),
      email: _readString(data['email']),
      role: _readString(data['role'], fallback: 'tourist'),
      city: _readString(data['city']),
      createdAt: _readDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'city': city,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? city,
    DateTime? createdAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      city: city ?? this.city,
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
