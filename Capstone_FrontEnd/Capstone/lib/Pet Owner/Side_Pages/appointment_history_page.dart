import 'package:flutter/material.dart';
import 'appointment_info_page.dart';

class AppointmentHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'APPOINTMENT HISTORY',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildHistoryItem(Icons.calendar_today, 'January 1, 2022', '10:00 AM', 'With John Doe', 'John Doe', context),
            _buildHistoryItem(Icons.calendar_today, 'February 15, 2022', '11:00 AM', 'With Alice Johnson', 'Alice Johnson', context),
            _buildHistoryItem(Icons.calendar_today, 'March 30, 2022', '09:30 AM', 'With Bob Smith', 'Bob Smith', context),
            // Add more history items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(IconData icon, String date, String time, String title, String ownerName, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentInfoPage(
              appointmentDate: date,
              appointmentTime: time,
              appointmentDescription: 'Description of the appointment',
              appointmentStatus: 'Scheduled',
              appointmentCategory: 'Checkup',
              appointmentPet: 'Fluffy',
              petOwnerName: ownerName,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      date,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
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
