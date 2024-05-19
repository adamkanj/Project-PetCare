import 'package:flutter/material.dart';
import 'Side_Pages/profile_page.dart';
import 'Side_Pages/notifications_page.dart';
import 'equipment_manager.dart';
import 'vet_manager.dart';
import 'product_manager.dart';
import 'appointment_manager.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      fontFamily: 'Arial',
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: ManageSystemScreen(),
  ));
}

class ManageSystemScreen extends StatefulWidget {
  @override
  _ManageSystemScreenState createState() => _ManageSystemScreenState();
}

class _ManageSystemScreenState extends State<ManageSystemScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions; // Declare as late

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      buildBusinessTab(),
      NotificationsPage(),
      ProfilePage(),
    ];
  }

  Widget buildBusinessTab() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.0,
      children: List.generate(jobCategories.length, (index) {
        return Card(
          color: jobCategories[index].color,
          elevation: 5,
          margin: EdgeInsets.all(8),
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              if (jobCategories[index].destination != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => jobCategories[index].destination!));
              } else {
                print("No navigation set for ${jobCategories[index].name}");
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(jobCategories[index].icon, size: 60, color: Colors.white),
                  SizedBox(height: 8),
                  Text(jobCategories[index].name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (jobCategories[index].data != null)
                    Text('${jobCategories[index].data}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
        );
      }),
    );
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
          backgroundColor: Colors.black,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.pets, color: Colors.white),
                onPressed: () {},
              ),
              Text('PetCare', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
      ),
    );
  }
}

class JobCategory {
  final IconData icon;
  final String name;
  final Color color;
  final int? data;
  final Widget? destination;

  JobCategory({required this.icon, required this.name, required this.color, this.data, this.destination});
}

List<JobCategory> jobCategories = [
  JobCategory(icon: Icons.check_circle, name: 'Active Veterinarians', color: Colors.greenAccent, data: 32),
  JobCategory(icon: Icons.event, name: 'Today\'s Appointments', color: Colors.blueAccent, data: 15),
  JobCategory(icon: Icons.local_hospital, name: 'Manage Veterinarian', color: Colors.blueGrey, destination: VetManager()),
  JobCategory(icon: Icons.calendar_today, name: 'Manage Appointments', color: Colors.blueGrey, destination: AppointmentsPage()),
  JobCategory(icon: Icons.build, name: 'Manage Equipment', color: Colors.blueGrey, destination: EquipmentManager()),
  JobCategory(icon: Icons.shopping_cart, name: 'Manage Products', color: Colors.blueGrey, destination: ProductManager()),
];
