import 'package:flutter/material.dart';
import 'contact_us_page.dart';
import 'faq_page.dart';

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'HELP CENTER',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildHelpCenterItem(Icons.help_outline, 'FAQs', context, FAQPage()),
            _buildHelpCenterItem(Icons.email, 'Contact Us', context, ContactUsPage()),
            // Add more help center items as needed
          ],
        ),
      ),
    );
  }
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildHelpCenterItem(IconData icon, String title, BuildContext context, Widget page) {
    return InkWell(
      onTap: () => _navigateTo(context, page),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}