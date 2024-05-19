class ReviewProduct {
  final int productReviewId;
  final int? ownerId;
  final int? productId;
  final int? rating;
  final String? comment;
  final DateTime? date;

  ReviewProduct({
    required this.productReviewId,
    this.ownerId,
    this.productId,
    this.rating,
    this.comment,
    this.date,
  });

  // Converts a ReviewResource object to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'productReviewId': productReviewId,
      'ownerId': ownerId,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'date': date?.toIso8601String(), // Use ISO 8601 format
    };
  }

  // Creates a ReviewResource object from a JSON map.
  factory ReviewProduct.fromJson(Map<String, dynamic> json) {
    return ReviewProduct(
      productReviewId: json['productReviewId'] as int,
      ownerId: json['ownerId'] as int?,
      productId: json['productId'] as int?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}
