class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviews;
  final String description;
  final String image;
  final String? badge;
  final List<int> availableColorValues;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.image,
    this.badge,
    this.availableColorValues = const [0xFF0F172A, 0xFF64748B, 0xFFE2E8F0],
  });

  Product copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    double? rating,
    int? reviews,
    String? description,
    String? image,
    String? badge,
    List<int>? availableColorValues,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      description: description ?? this.description,
      image: image ?? this.image,
      badge: badge ?? this.badge,
      availableColorValues: availableColorValues ?? this.availableColorValues,
    );
  }
}
