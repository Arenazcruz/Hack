import 'package:cloud_firestore/cloud_firestore.dart';

class EntrepreneurProduct {
  const EntrepreneurProduct({
    required this.id,
    required this.ownerUid,
    required this.businessId,
    required this.name,
    required this.description,
    required this.category,
    required this.city,
    this.price,
    this.available = true,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String ownerUid;
  final String businessId;
  final String name;
  final String description;
  final String category;
  final double? price;
  final String city;
  final bool available;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory EntrepreneurProduct.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};

    return EntrepreneurProduct(
      id: _readString(data['id']),
      ownerUid: _readString(data['ownerUid']),
      businessId: _readString(data['businessId']),
      name: _readString(data['name']),
      description: _readString(data['description']),
      category: _readString(data['category']),
      price: _readNullableDouble(data['price']),
      city: _readString(data['city']),
      available: data['available'] is bool ? data['available'] as bool : true,
      imageUrl: _readNullableString(data['imageUrl']),
      createdAt: _readNullableDateTime(data['createdAt']),
      updatedAt: _readNullableDateTime(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerUid': ownerUid,
      'businessId': businessId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'city': city,
      'available': available,
      'imageUrl': imageUrl,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  EntrepreneurProduct copyWith({
    String? id,
    String? ownerUid,
    String? businessId,
    String? name,
    String? description,
    String? category,
    double? price,
    bool clearPrice = false,
    String? city,
    bool? available,
    String? imageUrl,
    bool clearImageUrl = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EntrepreneurProduct(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: clearPrice ? null : price ?? this.price,
      city: city ?? this.city,
      available: available ?? this.available,
      imageUrl: clearImageUrl ? null : imageUrl ?? this.imageUrl,
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

double? _readNullableDouble(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    return double.tryParse(value.replaceAll(',', '.'));
  }

  return null;
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
