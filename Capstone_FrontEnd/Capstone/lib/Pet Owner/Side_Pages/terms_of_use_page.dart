import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'TERMS OF USE',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TERMS OF USE FOR PETS & VETS MOBILE APP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the Pets & Vets Mobile App. Please read these terms carefully before using our services.\n\n'
                  '1. **Acceptance of Terms**\n   By accessing or using our mobile application, you agree to be bound by these terms and conditions (Terms of Use).\n\n'
                  '2. **Services Offered**\n   The Pets & Vets Mobile App provides users with access to comprehensive veterinary care information, pet health management tools, appointment scheduling, and emergency pet care options.\n\n'
                  '3. **User Responsibilities**\n   You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. You agree to use our services for lawful purposes only.\n\n'
                  '4. **Content Ownership**\n   All content provided on the app is owned by Pets & Vets or its content suppliers. This content includes, but is not limited to, text, graphics, images, and software.\n\n'
                  '5. **Privacy Policy**\n   Your use of the app is also governed by the Pets & Vets Privacy Policy, which informs users of our data collection and usage.\n\n'
                  '6. **Changes to Terms**\n   Pets & Vets reserves the right to modify these terms at any time. Your continued use of the app after any such changes take effect constitutes your acceptance of the new terms.\n\n'
                  '7. **Termination**\n   Pets & Vets may terminate your access to all or any part of the app at any time, with or without cause, with or without notice, effective immediately.\n\n'
                  '8. **Disclaimer of Warranties**\n   The app is provided "as is". Pets & Vets and its suppliers and licensors hereby disclaim all warranties of any kind, express or implied, including, without limitation, the warranties of merchantability, fitness for a particular purpose and non-infringement.\n\n'
                  '9. **Limitation of Liability**\n   In no event will Pets & Vets, or its suppliers or licensors, be liable with respect to any subject matter of this agreement under any contract, negligence, strict liability or other legal or equitable theory for: (i) any special, incidental or consequential damages; (ii) the cost of procurement for substitute products or services; (iii) for interruption of use or loss or corruption of data.\n\n'
                  '10. **Governing Law**\n    These terms will be governed by and construed in accordance with the laws of the jurisdiction in which our company is based, without regard to its conflict of law provisions.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {}, // Implement your decline logic
                  child: Text('Decline'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // red color for the decline button
                  ),
                ),
                ElevatedButton(
                  onPressed: () {}, // Implement your accept logic
                  child: Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // green color for the accept button
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
