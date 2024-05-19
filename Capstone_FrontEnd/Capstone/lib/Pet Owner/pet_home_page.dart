import 'package:flutter/material.dart';
import 'pets_page.dart';
import 'petshop_page.dart';
import 'Side_Pages/profile_page.dart';
import 'Side_Pages/notifications_page.dart';
import 'services.dart';
import 'calendar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomeScreen(),
    PetsPage(),
    PetShopPage(),
    ServicesPage(),
    AppointmentsPage(),
  ];
  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue[800],  // Richer color for AppBar
          title: Text('PetCare', style: TextStyle(fontSize: 20, color: Colors.white)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              color: Colors.white,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage())),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              color: Colors.white,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Pet Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Calendar'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],  // Highlight with a warm color
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,  // Fixed type with background
        backgroundColor: Colors.white,  // Light background in the nav bar
      ),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome to the ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'Home of Pets!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = LinearGradient(
                        colors: <Color>[Colors.blue, Colors.purple],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'What do you want to do today:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Added padding for better spacing
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColoredButton(context, 'Request Appointment', Colors.green, () {
                  context.findAncestorStateOfType<_HomePageState>()!.updateSelectedIndex(3);
                }),
                SizedBox(width: 8),
                _buildColoredButton(context, 'Purchase Products', Colors.blue, () {
                  context.findAncestorStateOfType<_HomePageState>()!.updateSelectedIndex(2);
                }),
                SizedBox(width: 8),
                _buildColoredButton(context, 'Create To Do', Colors.orange, () {
                  context.findAncestorStateOfType<_HomePageState>()!.updateSelectedIndex(4);
                }),
                SizedBox(width: 8),
                _buildColoredButton(context, 'Review Pet Info', Colors.red, () {
                  context.findAncestorStateOfType<_HomePageState>()!.updateSelectedIndex(1);
                }),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Colors.grey[200],  // Light background for contrast
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                PetFactCard(title: 'Dogs have dreams too !', description: 'Scientific evidence, based on brain wave patterns, suggests that dogs dream just like us. You can tell when a dog is dreaming by observing their body movements and facial expressions while they sleep. It has been mooted that they mostly dream about playing or spending time with their owners. In case you were curious, yes, they can, apparently, also have bad dreams and nightmares. ', imagePath: 'assets/dog_dreaming.jpg', sourceUrl: 'https://www.purina.co.uk/articles/dogs/behaviour/common-questions/amazing-dog-facts'),
                PetFactCard(title: 'Cats are Sleepy Heads', description: 'If you share your home with a cat, you know that your fur baby can be found sleeping in a sunny spot most of the time. That’s because cats spend around 70 percent of their lives sleeping, according to FunKids. Maybe they are saving energy to be ready to pounce, play, and purr when you come home from work.', imagePath: 'assets/cat_sleepy.jpg', sourceUrl: 'https://www.goodnet.org/articles/9-fun-facts-about-pets-to-make-you-smile'),
                PetFactCard(title: 'Hamsters are banned in Hawaii', description: 'Hamsters are one of the most popular pets in the UK! However, in Hawaii they are illegal to own. It’s because if hamsters escape and breed, they could end up destroying plants and other animals.', imagePath: 'assets/hamster.jpg', sourceUrl: 'https://www.funkidslive.com/learn/top-10-facts/top-10-facts-about-pets/'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class PetFactCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String sourceUrl;

  PetFactCard({required this.title, required this.description, required this.imagePath, required this.sourceUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, height: 150, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(description, style: TextStyle(fontSize: 14)),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {},  // Insert navigation logic if necessary
                  child: Text(sourceUrl, style: TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
