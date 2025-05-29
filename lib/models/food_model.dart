class Review {
  final int rating;
  final String comment;
  final String date;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}

class FoodModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final double rating;
  List<Review> reviews;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isAvailable = true,
    this.rating = 4.0,
    this.reviews = const [],
  });

  double get averageRating {
    if (reviews.isEmpty) return 0;
    final total = reviews.map((r) => r.rating).reduce((a, b) => a + b);
    return total / reviews.length;
  }

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      isAvailable: json['isAvailable'] ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      reviews: json['reviews'] != null
          ? List<Review>.from(json['reviews'].map((r) => Review.fromJson(r)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviews': reviews.map((r) => r.toJson()).toList(),
    };
  }
}
