class Experience {
  const Experience({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.city,
    required this.price,
    required this.description,
    this.imageUrl,
  });

  final String id;
  final String ownerId;
  final String title;
  final String city;
  final double price;
  final String description;
  final String? imageUrl;
}
