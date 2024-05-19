import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(
                'Push Notifications',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'Receive push notifications for appointments, reminders, and pet pickups',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              value: true, // Set initial value, you can change this based on user preferences
              onChanged: (value) {
                // Update notification settings
              },
            ),
            SwitchListTile(
              title: Text(
                'Email Notifications',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'Receive an email for appointment confirmations, reminders, and pet pickups',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              value: false, // Set initial value, you can change this based on user preferences
              onChanged: (value) {
                // Update notification settings
              },
            ),
            SwitchListTile(
              title: Text(
                'SMS Notifications',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'Receive an SMS for appointment reminders and pet pickups. Message and data rates apply. Message frequency varies. Text HELP for help, STOP to cancel.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              value: true, // Set initial value, you can change this based on user preferences
              onChanged: (value) {
                // Update notification settings
              },
            ),
          ],
        ),
      ),
    );
  }
}
