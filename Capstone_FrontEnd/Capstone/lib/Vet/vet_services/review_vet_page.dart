import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../ApiHandler.dart';
import '../../IdProvider.dart';
import '../../models/for_vet/review.dart';
import 'package:provider/provider.dart';
// ReviewPage which displays a list of reviews
class ReviewPage extends StatelessWidget {
  Future<List<Review>> _fetchProducts(BuildContext context) async {
    int vetId = Provider.of<IdProvider>(context, listen: false).id!;
    try {
      return ApiHandler().getReviewsByVetId(vetId);
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

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
            child: FutureBuilder<List<Review>>(
              future: _fetchProducts(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  double overallRating = _calculateOverallRating(snapshot.data!);
                  return Text(
                    'Overall Rating: ${overallRating.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Review>>(
              future: _fetchProducts(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => _buildReviewCard(context, snapshot.data![index]),
                  );
                }
              },
            ),
          ),
        ],
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
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150/00FFFF/000000?Text=CharlieD'),
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
              itemBuilder: (context, _) => Icon(
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
  }

  double _calculateOverallRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0;
    double totalRating = 0;
    for (var review in reviews) {
      totalRating += review.rating;
    }
    return totalRating / reviews.length;
  }
}
