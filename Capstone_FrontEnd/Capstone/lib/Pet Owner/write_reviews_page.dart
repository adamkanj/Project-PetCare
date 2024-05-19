import 'package:flutter/material.dart';
import '../IdProvider.dart';
import '../models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/for_pet_owner/ReviewProduct.dart';
import '../../ApiHandler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class WriteReviewPage extends StatefulWidget {
  final Product product;

  WriteReviewPage({Key? key, required this.product}) : super(key: key);

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final TextEditingController _commentController = TextEditingController();
  int _currentRating = 3;  // Default or initial rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review for ${widget.product.name}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate the product:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _currentRating.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _currentRating = rating.round();
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Enter your review here',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Assuming you have an IdProvider and ApiHandler properly set up
                ReviewProduct review = ReviewProduct(
                  productReviewId: 0,
                  ownerId: Provider.of<IdProvider>(context, listen: false).id,  // Correct this line as per your implementation
                  productId: widget.product.productId,
                  rating: _currentRating,
                  comment: _commentController.text,
                  date: DateTime.now(),
                );

                var apiHandler = ApiHandler();
                try {
                  bool savedReview = await apiHandler.createProductReview(review) ?? false;  // Ensure this method is expecting a ReviewProduct
                  if (savedReview) {
                    Navigator.pop(context, true); // Indicates successful review submission
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save review')));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving review: $e')));
                }
              },
              child: Text('Submit Review',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

