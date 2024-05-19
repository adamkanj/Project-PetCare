import 'package:flutter/material.dart';
import 'dart:async';
import '../../ApiHandler.dart'; // Adjust path to ApiHandler class as necessary
import '../../models/veterinarian.dart'; // Adjust path as necessary
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/for_vet/review.dart';
import 'vet_reviews_page.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Veterinarian> veterinarians = [];
  List<Veterinarian> filteredVeterinarians = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchAndStoreVeterinarians();
  }

  void _fetchAndStoreVeterinarians() async {
    try {
      ApiHandler apiHandler = ApiHandler(); // Create an instance of ApiHandler
      List<Veterinarian> vets = await apiHandler.fetchVeterinarians();
      setState(() {
        veterinarians = vets;
        filteredVeterinarians = vets;
      });
    } catch (e) {
      print('Error fetching veterinarians: $e');
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredVeterinarians = veterinarians.where((vet) {
        bool matchesFirstName = vet.firstName?.toLowerCase().contains(query) ?? false;
        bool matchesLastName = vet.lastName?.toLowerCase().contains(query) ?? false;
        return matchesFirstName || matchesLastName;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Vet Ratings', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredVeterinarians.length,
              itemBuilder: (context, index) {
                return VetCardWidget(
                  vet: filteredVeterinarians[index]
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class VetCardWidget extends StatefulWidget {
  final Veterinarian vet;

  const VetCardWidget({Key? key, required this.vet}) : super(key: key);

  @override
  _VetCardWidgetState createState() => _VetCardWidgetState();
}

class _VetCardWidgetState extends State<VetCardWidget> {
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchRatings();
  }

  Future<void> _fetchRatings() async {
    ApiHandler apiHandler = ApiHandler(); // Ensure this is your API handler with the correct function
    try {
      List<Review> reviews = await apiHandler.getReviewsByVetId(widget.vet.id);
      double overallRating = _calculateOverallRating(reviews);
      setState(() {
        _rating = overallRating;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  double _calculateOverallRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0;
    double totalRating = 0;
    for (var review in reviews) {
      totalRating += review.rating;
    }
    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VetReviewsPage(vetId: widget.vet.id, vetName: "${widget.vet.firstName} ${widget.vet.lastName}"),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: widget.vet.image != null && widget.vet.image!.isNotEmpty
                ? MemoryImage(widget.vet.image!)
                : AssetImage('assets/placeholder.png') as ImageProvider,
          ),
          title: Text('${widget.vet.firstName ?? "No First Name"} ${widget.vet.lastName ?? "No Last Name"}'),
          subtitle: Text('Specialty: ${widget.vet.specialty ?? "N/A"}'),
          trailing: RatingBarIndicator(
            rating: _rating,  // This should ideally be fetched or calculated based on real data
            itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}