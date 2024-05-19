import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<FAQItem> _faqItems = generateFAQItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("FAQ", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _faqItems[index].isExpanded = !isExpanded;
              });
            },
            children: _faqItems.map<ExpansionPanel>((FAQItem item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(item.question, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(item.answer),
                ),
                isExpanded: item.isExpanded,
                canTapOnHeader: true,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  static List<FAQItem> generateFAQItems() {
    return [
      FAQItem(
        question: 'What vaccinations are necessary for my pet?',
        answer: 'Core vaccinations for dogs include rabies, distemper, parvovirus, and adenovirus. For cats, essential vaccines are panleukopenia, calicivirus, rabies, and herpesvirus.',
        isExpanded: false,
      ),
      FAQItem(
        question: 'How often should my pet visit the vet?',
        answer: 'Pets should have at least one veterinary examination per year. For younger pets, senior pets, or those with health issues, more frequent visits may be necessary.',
        isExpanded: false,
      ),
      FAQItem(
        question: 'What should I do if my pet has an emergency?',
        answer: 'In case of an emergency, immediately contact your vet or the nearest emergency veterinary service. Keep emergency contact numbers handy at all times.',
        isExpanded: false,
      ),
      FAQItem(
        question: 'How can I tell if my pet is sick?',
        answer: 'Signs of illness in pets can include lethargy, loss of appetite, vomiting, diarrhea, or other abnormal behavior. Consult your vet if you notice any of these symptoms.',
        isExpanded: false,
      ),
      FAQItem(
        question: 'What diet is best for my pet?',
        answer: 'The best diet for your pet depends on their species, age, weight, and health condition. Consult your vet to recommend a diet suited for your pet\'s specific needs.',
        isExpanded: false,
      ),
    ];
  }
}

class FAQItem {
  String question;
  String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
