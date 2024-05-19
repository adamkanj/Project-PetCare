import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8 || value.length > 32) {
                  return 'Password must be between 8 and 32 characters';
                }
                if (!value.contains(RegExp(r'[A-Z]'))) {
                  return 'Password must contain at least one capitalized character';
                }
                if (!value.contains(RegExp(r'[0-9]'))) {
                  return 'Password must contain at least one numeric character';
                }
                if (!value.contains(RegExp(r'[!@#\$%^&*()_+{}|"?><.,]'))) {
                  return 'Password must contain at least one symbol';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            Text(
              'Password Requirements:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              '- Passwords must be between 8-32 characters.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '- Password contains at least one capitalized character.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '- Password contains at least one numeric character.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '- Password contains at least one symbol (ex: !, @, #, %, ^, &, *, etc.).',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to change password
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
