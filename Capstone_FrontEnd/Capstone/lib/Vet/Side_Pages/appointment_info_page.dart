import 'package:flutter/material.dart';

class AppointmentInfoPage extends StatelessWidget {
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentDescription;
  final String appointmentStatus;
  final String appointmentCategory;
  final String appointmentPet;
  final String petOwnerName;

  AppointmentInfoPage({
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentDescription,
    required this.appointmentStatus,
    required this.appointmentCategory,
    required this.appointmentPet,
    required this.petOwnerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(petOwnerName),  // Using the pet owner's name as the title
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(  // Changed to ListView for better scrolling and space management
          children: [
            _buildDetailItem('Date & Time:', '$appointmentDate at $appointmentTime'),
            _buildDetailItem('Status:', appointmentStatus),
            _buildDetailItem('Category:', appointmentCategory),
            _buildDetailItem('Pet:', appointmentPet),
            _buildDetailItem('Description:', appointmentDescription),
            SizedBox(height: 30),  // Added more space above the button
            ElevatedButton(
              onPressed: () {
                // TODO: Trigger API call to delete the appointment
                // Example: API.deleteAppointment(appointmentId)
                Navigator.pop(context); // Optionally pop the context after deletion
              },
              child: Text('Delete Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,  // Correct property for background color
                foregroundColor: Colors.white, // Correct property for text color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),  // Better padding for button
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
