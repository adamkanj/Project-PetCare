class ReviewVet {
  final int? reviewId;
  final int? ownerId;
  final int? vetId;
  final int? rating;
  final String? comment;
  final DateTime? date;

  ReviewVet({
    this.reviewId,
    this.ownerId,
    this.vetId,
    this.rating,
    this.comment,
    this.date,
  });

  // Converts a ReviewResource object to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'ownerId': ownerId,
      'vetId': vetId,
      'rating': rating,
      'comment': comment,
      'date': date?.toIso8601String(), // Use ISO 8601 format
    };
  }

  // Creates a ReviewResource object from a JSON map.
  factory ReviewVet.fromJson(Map<String, dynamic> json) {
    return ReviewVet(
      reviewId: json['reviewId'] as int?,
      ownerId: json['ownerId'] as int?,
      vetId: json['vetId'] as int?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}
