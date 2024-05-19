// Definition of the Review class
class Review {
  final String firstName;
  final String lastName;
  final int rating;
  final String comment;
  final DateTime date;

  Review({
    required this.firstName,
    required this.lastName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
