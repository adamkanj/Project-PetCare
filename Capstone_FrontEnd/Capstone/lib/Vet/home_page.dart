import 'package:flutter/material.dart';
import 'package:petcare/Vet/appointment_manage/appointments_page.dart';
import 'package:petcare/Vet/vet_services/review_vet_page.dart';
import 'package:petcare/Vet/vet_services/records_page.dart';
//import 'package:petcare/Vet/vet_services/appointments_page.dart';
import 'package:petcare/Vet/vet_services/vaccine_history_page.dart';
import 'Side_Pages/notifications_page.dart';
import 'Side_Pages/profile_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/for_vet/review.dart';
import '../../ApiHandler.dart';
import '../../IdProvider.dart';
import '../../models/for_vet/review.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [
    ServicesPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.pets, color: Colors.white),  // Paw icon
            SizedBox(width: 10),
            Text('PetCare', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {
      'title': 'View & Update Medical Records',
      'color': Colors.blue,
      'icon': Icons.description,
      'page': MedicalRecordsPage(),
    },
    {
      'title': 'View Vaccination History',
      'color': Colors.grey,
      'icon': Icons.history,
      'page': VaccinationHistoryPage(),
    },
    {
      'title': 'View & Manage Appointments',
      'color': Colors.deepOrangeAccent,
      'icon': Icons.calendar_today,
      'page': AppointmentsPage(),
      //AppointmentsPage()
    },
    {
      'title': 'View Client Reviews',
      'color': Colors.green,
      'icon': Icons.rate_review,
      'page': ReviewPage(),
    },
  ];

  final List<String> imgList = [
    'assets/Checkup1.jpeg',
    'assets/Checkup2.jpeg',
    'assets/Checkup3.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Vet Services', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white60,  // Softer background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(0, 2),  // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(15),  // Rounded corners
            ),
            margin: EdgeInsets.all(8),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2),  // Faster interval for smoother animation
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                viewportFraction: 0.8,  // Adjust viewport fraction for better focus on central image
              ),
              items: imgList.map((item) => ClipRRect(  // Rounded corners for images
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(item, fit: BoxFit.cover),
              )).toList(),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceButton(
                context,
                services[index]['title'],
                services[index]['color'],
                services[index]['icon'],
                services[index]['page'],
              );
            },
          ),
          RecentReviewsCarousel(),
        ],
      ),
    );
  }

  Widget _buildServiceButton(BuildContext context, String title, Color color, IconData icon, Widget page) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(16),
          textStyle: TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48),
            SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
class RecentReviewsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: fetchProducts(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Review> reviews = snapshot.data!;
          reviews.sort((a, b) => b.date.compareTo(a.date)); // Sort reviews by date, newest first
          List<Review> recentReviews = reviews.take(3).toList(); // Take the top 3 recent reviews

          return Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                enlargeCenterPage: true,
                height: 200, // Adjust height according to your layout
                viewportFraction: 0.85, // Display a portion of the next and previous items
              ),
              items: recentReviews.map((review) => Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage('https://via.placeholder.com/150/00FFFF/000000?Text=CharlieD'),
                          ),
                          title: Text('${review.firstName} ${review.lastName}'),
                          subtitle: Text(review.date.toIso8601String().substring(0, 10)), // Adjust format as needed
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            review.comment,
                            style: TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: RatingBarIndicator(
                            rating: review.rating.toDouble(),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )).toList(),
            ),
          );
        }
      },
    );
  }

  Future<List<Review>> fetchProducts(BuildContext context) async {
    int vetId = Provider.of<IdProvider>(context, listen: false).id!;
    try {
      return ApiHandler().getReviewsByVetId(vetId);
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}


  Widget _buildReviewCard(BuildContext context, Review review) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),  // Corrected EdgeInsets usage
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


