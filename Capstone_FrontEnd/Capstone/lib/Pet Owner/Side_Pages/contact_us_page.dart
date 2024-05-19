import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Contact Us', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in Touch',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('+1 (911) 111-222'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('petcare.tech_support.info@gmail.com'),
            ),
            Text(
              'Social Media',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.facebook),
              title: Text('Follow us on Facebook'),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Discover beauty of our brand on Instagram'),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Real-time updates on Twitter'),
            ),
          ],
        ),
      ),
    );
  }
}
