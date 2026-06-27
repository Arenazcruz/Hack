import 'package:cloud_firestore/cloud_firestore.dart';

class EntrepreneurProfile {
  const EntrepreneurProfile({
    required this.id,
    required this.uid,
    required this.ownerName,
    required this.businessName,
    required this.city,
    required this.location,
    required this.category,
    required this.description,
    required this.phone,
    this.socialUrl,
    this.website,
    this.imageUrl,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String uid;
  final String ownerName;
  final String businessName;
  final String city;
  final String location;
  final String category;
  final String description;
  final String phone;
  final String? socialUrl;
  final String? website;
  final String? imageUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory EntrepreneurProfile.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};

    return EntrepreneurProfile(
      id: _readString(data['id']),
      uid: _readString(data['uid']),
      ownerName: _readString(data['ownerName']),
      businessName: _readString(data['businessName']),
      city: _readString(data['city']),
      location: _readString(data['location']),
      category: _readString(data['category']),
      description: _readString(data['description']),
      phone: _readString(data['phone']),
      socialUrl: _readNullableString(data['socialUrl']),
      website: _readNullableString(data['website']),
      imageUrl: _readNullableString(data['imageUrl']),
      status: _readString(data['status'], fallback: 'active'),
      createdAt: _readNullableDateTime(data['createdAt']),
      updatedAt: _readNullableDateTime(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'ownerName': ownerName,
      'businessName': businessName,
      'city': city,
      'location': location,
      'category': category,
      'description': description,
      'phone': phone,
      'socialUrl': socialUrl,
      'website': website,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  EntrepreneurProfile copyWith({
    String? id,
    String? uid,
    String? ownerName,
    String? businessName,
    String? city,
    String? location,
    String? category,
    String? description,
    String? phone,
    String? socialUrl,
    String? website,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EntrepreneurProfile(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      ownerName: ownerName ?? this.ownerName,
      businessName: businessName ?? this.businessName,
      city: city ?? this.city,
      location: location ?? this.location,
      category: category ?? this.category,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      socialUrl: socialUrl ?? this.socialUrl,
      website: website ?? this.website,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

String? _readNullableString(Object? value) {
  if (value == null) {
    return null;
  }

  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

DateTime? _readNullableDateTime(Object? value) {
  if (value == null) {
    return null;
  }

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
    return DateTime.tryParse(value);
  }

  return null;
}
