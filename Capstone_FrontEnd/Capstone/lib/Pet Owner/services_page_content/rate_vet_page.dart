import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../IdProvider.dart';
import '../../models/for_pet_owner/ReviewVet.dart';
import '../../ApiHandler.dart';

class RateVetPage extends StatefulWidget {
  final int vetId;
  final String vetName;

  RateVetPage({Key? key, required this.vetId, required this.vetName}) : super(key: key);

  @override
  _RateVetPageState createState() => _RateVetPageState();
}

class _RateVetPageState extends State<RateVetPage> {
  int _currentRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate ${widget.vetName}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate the Vet:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _currentRating.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
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
            // Inside the onPressed callback
            ElevatedButton(
              onPressed: () async {
                int providerId = Provider.of<IdProvider>(context, listen: false).id!;

                ReviewVet review = ReviewVet(
                  reviewId: 0,
                  ownerId: providerId,
                  vetId: widget.vetId,
                  rating: _currentRating,
                  comment: _commentController.text,
                  date: DateTime.now(),
                );

                try {
                  var apiHandler = ApiHandler();
                  bool? savedReview = await apiHandler.createReview(review);
                  if (savedReview == true) {
                    print('Review saved successfully');
                    Navigator.pop(context, true); // Pass `true` to indicate a new review
                  } else {
                    print('Failed to save review');
                  }
                } catch (e) {
                  print('Error saving review: $e');
                }
              },
              child: Text('Submit Review'),
            )

          ],
        ),
      ),
    );
  }
}
