import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true; // initial value, should be fetched from user settings
  bool _emailNotifications = false; // initial value, should be fetched from user settings
  bool _smsNotifications = true; // initial value, should be fetched from user settings

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
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                  // TODO: Update backend with new setting
                });
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
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                  // TODO: Update backend with new setting
                });
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
              value: _smsNotifications,
              onChanged: (value) {
                setState(() {
                  _smsNotifications = value;
                  // TODO: Update backend with new setting
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
