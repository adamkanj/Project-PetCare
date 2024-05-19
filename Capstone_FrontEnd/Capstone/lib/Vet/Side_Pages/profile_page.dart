import 'package:flutter/material.dart';
import 'notifications_settings_page.dart';
import 'appointment_history_page.dart';
import 'help_center_page.dart'; // Import the Help Center page
import 'privacy_policy_page.dart'; // Import the Privacy Policy page
import 'terms_of_use_page.dart'; // Import the Terms of Use page
import 'change_pass_page.dart'; // Import the Change Password page
import '../../login_page.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, String> userInfo = {
    'Name': 'John Doe',
    'Email': 'john.doe@example.com',
    'Phone': '+1234567890',
    'Gender': 'Male',
    'Date of Birth': 'January 1, 1990',
    'Address': '123 Main Street, City, Country',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'MY PROFILE',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildProfileCard(context),
            SizedBox(height: 20),
            _buildProfileRow(Icons.notifications, 'Notification Settings', context),
            _buildProfileRow(Icons.calendar_today, 'Appointment History', context),
            _buildProfileRow(Icons.help_outline, 'Help Center', context),
            _buildProfileRow(Icons.lock_outline, 'Privacy Policy', context),
            _buildProfileRow(Icons.description, 'Terms of Use', context),
            SizedBox(height: 20),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to profile/account information page
        _showAccountInfoDialog(context);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    // Placeholder for profile pic
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/default_profile_pic.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        // Implement logic to edit, add, delete, or replace profile picture
                        _editProfilePicture(context);
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo['Name'] ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userInfo['Email'] ?? '',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    userInfo['Phone'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String title, BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'Notification Settings') {
          // Navigate to notification settings page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
          );
        } else if (title == 'Appointment History') {
          // Navigate to appointment history page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentHistoryPage()),
          );
        } else if (title == 'Help Center') {
          // Navigate to help center page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpCenterPage()),
          );
        } else if (title == 'Privacy Policy') {
          // Navigate to privacy policy page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
          );
        } else if (title == 'Terms of Use') {
          // Navigate to terms of use page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TermsOfUsePage()),
          );
        }
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

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          // Perform logout action
          // For now, navigate to login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
        child: Text(
          'Log Out',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _showAccountInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile/Account Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Ensure minimum vertical space
            crossAxisAlignment: CrossAxisAlignment.start,
            children: userInfo.entries.map((entry) {
              return _buildInfoRow(Icons.person, entry.key, entry.value);
            }).toList()..addAll([
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity, // Ensure button width matches parent width
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to change password page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                    );
                  },
                  child: Text('Change Password'),
                ),
              ),
              SizedBox(height: 10), // Add space between buttons
              SizedBox(
                width: double.infinity, // Ensure button width matches parent width
                child: ElevatedButton(
                  onPressed: () {
                    // Perform delete account action
                    // For now, just close the dialog
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text('Delete Account'),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  void _editProfilePicture(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  // Implement logic to take a photo
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () {
                  // Implement logic to choose from gallery
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Remove Current Photo'),
                onTap: () {
                  // Implement logic to remove current photo
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title: $value',
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
