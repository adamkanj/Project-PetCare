import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/product.dart';
import '../models/for_vet/review.dart'; // Adjust path as necessary
import '../../ApiHandler.dart'; // Adjust path as necessary
import 'write_reviews_page.dart';

class ProductReviewsPage extends StatefulWidget {
  final Product product;

  ProductReviewsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductReviewsPageState createState() => _ProductReviewsPageState();
}

class _ProductReviewsPageState extends State<ProductReviewsPage> {
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _fetchReviews();
  }

  Future<List<Review>> _fetchReviews() async {
    try {
      // Assuming your API handler has a method to fetch reviews by product ID
      return ApiHandler().getProductReviewById(widget.product.productId);
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Reviews'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Review>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'There are no reviews for this product yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            return ListView(
              children: snapshot.data!
                  .map((review) => _buildReviewCard(context, review))
                  .toList(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WriteReviewPage(product: widget.product)),
            ).then((value) {
              if (value != null && value == true) {
                // If review was successfully added, refresh reviews
                setState(() {
                  _reviewsFuture = _fetchReviews();
                });
              }
            });

          },
          child: Text('Rate Vet'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Review review) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${review.firstName} ${review.lastName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            RatingBarIndicator(
              rating: review.rating.toDouble(),
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
            SizedBox(height: 8),
            Text(review.comment, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
              'Date: ${review.date.month}/${review.date.day}/${review.date.year}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
