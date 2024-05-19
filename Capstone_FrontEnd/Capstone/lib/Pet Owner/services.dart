import 'dart:async';
import 'package:flutter/material.dart';
import 'add_appointment.dart';
import 'services_page_content/vet_ratings_page.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final PageController _pageController;
  final _photos = [
    {
      'title': 'Annual Check-ups',
      'description': 'Ensure your pet’s health with yearly veterinary visits.',
      'imagePath': 'assets/Checkup1.jpeg',
    },
    {
      'title': 'Vaccination Services',
      'description': 'Keep your pet safe with up-to-date vaccinations.',
      'imagePath': 'assets/Checkup3.jpeg',
    },
    {
      'title': 'Pet Grooming',
      'description': 'Professional grooming services for your pet’s comfort and hygiene.',
      'imagePath': 'assets/Checkup2.jpeg',
    },
    // You can add more photos and descriptions as needed.
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _photos.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Services',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'All the services you need!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            _buildAutoScrollPhotoCarousel(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Request an appointment for a:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            _buildServiceCard(context, 'Medication Refill', Icons.medication),
            _buildServiceCard(context, 'Routine Check-ups', Icons.medical_services),
            _buildServiceCard(context, 'Grooming Services', Icons.cut),
            _buildServiceCard(context, 'Diagnostic Testing', Icons.local_hospital),
            _buildServiceCard(context, 'Dental Care', Icons.masks),
            _buildReviewCard(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _buildReviewCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: ListTile(
        leading: Icon(Icons.rate_review, color: Colors.blue),
        title: Text('Check Our Vet Ratings', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Read reviews and ratings of our veterinarians.'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewPage()),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String serviceName, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(serviceName),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentBookingPage(serviceName: serviceName)),
          );
        },
      ),
    );
  }

  Widget _buildAutoScrollPhotoCarousel() {
    return Container(
      height: 350, // Adjust height as needed
      child: PageView.builder(
        controller: _pageController,
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          return _buildPhotoWithInformation(
            _photos[index]['title']!,
            _photos[index]['description']!,
            _photos[index]['imagePath']!,
          );
        },
      ),
    );
  }

  Widget _buildPhotoWithInformation(String title, String description, String imagePath) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),  // Add space between title and description
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

