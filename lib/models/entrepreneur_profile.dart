import 'package:cloud_firestore/cloud_firestore.dart';

class EntrepreneurProfile {
  const EntrepreneurProfile({
    required this.id,
    required this.uid,
    required this.businessName,
    required this.ownerName,
    required this.description,
    required this.city,
    required this.category,
    required this.phone,
    required this.imageUrl,
    required this.createdAt,
  });

  final String id;
  final String uid;
  final String businessName;
  final String ownerName;
  final String description;
  final String city;
  final String category;
  final String phone;
  final String imageUrl;
  final DateTime createdAt;

  factory EntrepreneurProfile.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};

    return EntrepreneurProfile(
      id: _readString(data['id']),
      uid: _readString(data['uid']),
      businessName: _readString(data['businessName']),
      ownerName: _readString(data['ownerName']),
      description: _readString(data['description']),
      city: _readString(data['city']),
      category: _readString(data['category'], fallback: 'gastronomia'),
      phone: _readString(data['phone']),
      imageUrl: _readString(data['imageUrl']),
      createdAt: _readDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'businessName': businessName,
      'ownerName': ownerName,
      'description': description,
      'city': city,
      'category': category,
      'phone': phone,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  EntrepreneurProfile copyWith({
    String? id,
    String? uid,
    String? businessName,
    String? ownerName,
    String? description,
    String? city,
    String? category,
    String? phone,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return EntrepreneurProfile(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      description: description ?? this.description,
      city: city ?? this.city,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
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
