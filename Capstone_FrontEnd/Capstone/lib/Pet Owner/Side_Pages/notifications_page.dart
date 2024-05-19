import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../ApiHandler.dart';
import '../../models/for_vet/appointment.dart';
import '../../IdProvider.dart';
import 'package:provider/provider.dart';
import '../../models/notifications.dart';  // Update the import based on your file structure
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  final List<AppNotification> notifications;

  NotificationsPage({Key? key}) :
        notifications = [
          AppNotification(notificationId: 1, title: "Welcome!", content: "Thanks for joining us.", timestamp: DateTime.now().subtract(Duration(days: 1))),
          AppNotification(notificationId: 2, title: "Reminder", content: "Your appointment is tomorrow.", timestamp: DateTime.now()),
          // Assume some notifications might not have a timestamp
          AppNotification(notificationId: 3, title: "Old Notification", content: "This is an older message.", timestamp: null),
        ],
        super(key: key) {
    // Sort notifications by timestamp in descending order, handling possible nulls
    notifications.sort((a, b) {
      // Handle null timestamps by treating them as less recent
      if (a.timestamp == null && b.timestamp == null) return 0;
      if (a.timestamp == null) return 1; // nulls at the end
      if (b.timestamp == null) return -1; // non-nulls at the start
      return b.timestamp!.compareTo(a.timestamp!); // Compare non-null timestamps
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MESSAGES'),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: Colors.grey.shade300, height: 1),
        ),
        itemBuilder: (context, index) {
          AppNotification notification = notifications[index];
          return Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ]
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Text(
                notification.title ?? "No title",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.content ?? "No content",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.timestamp != null ? DateFormat('yyyy-MM-dd – kk:mm').format(notification.timestamp!) : 'No date',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              onTap: () {
                // Action to take when notification is tapped
              },
            ),
          );
        },
      ),
    );
  }
}
