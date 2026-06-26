import 'package:cloud_firestore/cloud_firestore.dart';

class GastronomicExperience {
  const GastronomicExperience({
    required this.id,
    required this.entrepreneurId,
    required this.title,
    required this.description,
    required this.city,
    required this.location,
    required this.price,
    required this.duration,
    required this.foods,
    required this.imageUrl,
    required this.aiStory,
    required this.aiTouristDescription,
    required this.createdAt,
  });

  final String id;
  final String entrepreneurId;
  final String title;
  final String description;
  final String city;
  final String location;
  final double price;
  final String duration;
  final List<String> foods;
  final String imageUrl;
  final String aiStory;
  final String aiTouristDescription;
  final DateTime createdAt;

  factory GastronomicExperience.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};

    return GastronomicExperience(
      id: _readString(data['id']),
      entrepreneurId: _readString(data['entrepreneurId']),
      title: _readString(data['title']),
      description: _readString(data['description']),
      city: _readString(data['city']),
      location: _readString(data['location']),
      price: _readDouble(data['price']),
      duration: _readString(data['duration']),
      foods: _readStringList(data['foods']),
      imageUrl: _readString(data['imageUrl']),
      aiStory: _readString(data['aiStory']),
      aiTouristDescription: _readString(data['aiTouristDescription']),
      createdAt: _readDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entrepreneurId': entrepreneurId,
      'title': title,
      'description': description,
      'city': city,
      'location': location,
      'price': price,
      'duration': duration,
      'foods': foods,
      'imageUrl': imageUrl,
      'aiStory': aiStory,
      'aiTouristDescription': aiTouristDescription,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  GastronomicExperience copyWith({
    String? id,
    String? entrepreneurId,
    String? title,
    String? description,
    String? city,
    String? location,
    double? price,
    String? duration,
    List<String>? foods,
    String? imageUrl,
    String? aiStory,
    String? aiTouristDescription,
    DateTime? createdAt,
  }) {
    return GastronomicExperience(
      id: id ?? this.id,
      entrepreneurId: entrepreneurId ?? this.entrepreneurId,
      title: title ?? this.title,
      description: description ?? this.description,
      city: city ?? this.city,
      location: location ?? this.location,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      foods: foods ?? this.foods,
      imageUrl: imageUrl ?? this.imageUrl,
      aiStory: aiStory ?? this.aiStory,
      aiTouristDescription: aiTouristDescription ?? this.aiTouristDescription,
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
