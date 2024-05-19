import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MESSAGES'),
      ),
      body: Center(
        child: _buildNotificationsWidget(),
      ),
    );
  }

  Widget _buildNotificationsWidget() {
    // Check if there are any notifications
    bool hasNotifications = false; // Replace with your logic to check notifications

    if (hasNotifications) {
      // If there are notifications, display them
      return ListView.builder(
        itemCount: 5, // Replace with the number of notifications
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Notification ${index + 1}'),
            subtitle: Text('Notification description'),
            onTap: () {
              // Action to take when notification is tapped
            },
          );
        },
      );
    } else {
      // If there are no notifications, display a message and an image
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Empty_inbox.jpg', // Image asset path
            height: 150, // Adjust height as needed
          ),
          SizedBox(height: 20),
          Text(
            "You don't have any messages",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'View your notifications here',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      );
    }
  }
}

