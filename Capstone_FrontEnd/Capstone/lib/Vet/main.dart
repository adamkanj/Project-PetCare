import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(MyApp());

}

class Review {
  final String firstName;
  final String lastName;
  final int rating;
  final String comment;
  final DateTime date;
  final String photoUrl; // New field for photo URL

  Review({
    required this.firstName,
    required this.lastName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.photoUrl, // Updated constructor
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet Reviews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReviewPage(),
    );
  }
}

class ReviewPage extends StatelessWidget {
  final List<Review> reviews = [
    Review(
      firstName: 'John',
      lastName: 'Doe',
      rating: 4,
      comment: 'Great service!',
      date: DateTime.now().subtract(Duration(days: 5)),
      photoUrl: 'https://via.placeholder.com/150', // Sample photo URL
    ),
    Review(
      firstName: 'Jane',
      lastName: 'Smith',
      rating: 5,
      comment: 'Excellent vet!',
      date: DateTime.now().subtract(Duration(days: 10)),
      photoUrl: 'https://via.placeholder.com/150', // Sample photo URL
    ),
    Review(
      firstName: 'Alice',
      lastName: 'Johnson',
      rating: 3,
      comment: 'Could improve',
      date: DateTime.now().subtract(Duration(days: 3)),
      photoUrl: 'https://via.placeholder.com/150', // Sample photo URL
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vet Reviews'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Overall Rating: ${_calculateOverallRating().toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(review.photoUrl),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${review.firstName} ${review.lastName}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        RatingBarIndicator(
                          rating: review.rating.toDouble(),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(height: 8),
                        Text(
                          review.comment,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Date: ${review.date.month}/${review.date.day}/${review.date.year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _calculateOverallRating() {
    if (reviews.isEmpty) return 0;
    double totalRating = 0;
    for (var review in reviews) {
      totalRating += review.rating;
    }
    return totalRating / reviews.length;
  }
}