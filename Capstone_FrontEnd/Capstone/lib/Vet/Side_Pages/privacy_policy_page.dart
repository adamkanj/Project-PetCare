import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'PRIVACY POLICY',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'PRIVACY POLICY\n\nPlease take a moment to read the following policy so you can understand how we treat your information. As we continuously improve and expand our services, this policy might change, so please check it periodically.\n\nThis Privacy Policy applies to the PetCare vet clinic app and related services (collectively, the "Services"). This policy describes how PetCare ("we," "us," "our") collects, uses, and shares information you provide through the Services. It also describes your rights and choices regarding our use and sharing of your information, including how you can access and update your information.\n\nYour use of the Services constitutes your agreement to our Terms of Use and acceptance of this Privacy Policy. If you have questions or comments about our Privacy Policy, please contact us as set forth in the section entitled "Contact Us."\n\nINFORMATION COLLECTION\n\nInformation You Provide\n\nPetCare collects information you provide directly via the app when you register an account, update your profile, use certain features, or participate in promotions. We collect basic information such as your name, email address, and details about your pets.\n\nInformation We Collect Automatically\n\nWhen you use our Services, we automatically collect information about your device and your usage of the Services through analytics tools. We may collect device identifiers, cookies, and similar technologies to improve our services and your experience.\n\nInformation From Third Parties\n\nWe may receive information about you from third parties such as other vet service providers or advertising networks, which we use to provide you with better services.\n\nUSE OF INFORMATION\n\nWe use the information we collect to provide, maintain, and improve our services, to communicate with you, to monitor the effectiveness of our marketing campaigns, and to provide personalized advice and advertisements.\n\nSHARING OF INFORMATION\n\nWe may share your information with trusted third parties who assist us in operating our services, conducting our business, or servicing you, so long as those parties agree to keep this information confidential. We may also release your information when we believe release is appropriate to comply with the law, enforce our site policies, or protect ours or others\' rights, property, or safety.\n\nHowever, non-personally identifiable visitor information may be provided to other parties for marketing, advertising, or other uses.\n\nYOUR RIGHTS\n\nYou have the right to access, correct, or delete your personal information stored by us. Contact us directly to request this.\n\nCHANGES TO THIS POLICY\n\nWe may update this Privacy Policy to reflect changes to our information practices. If we make any material changes, we will notify you by email (sent to the e-mail address specified in your account) or by means of a notice on this app prior to the change becoming effective.\n\nCONTACT US\n\nIf you have any questions about this Privacy Policy, please contact us at support@petcare.com.\n\n',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
