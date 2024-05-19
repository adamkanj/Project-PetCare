import 'dart:io';
import 'dart:convert'; // For image encoding
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../ApiHandler.dart'; // Ensure this is correctly pointing to your ApiHandler
import '../../models/veterinarian.dart'; // Ensure this is correctly pointing to your Veterinarian model
import 'dart:html' as html;

class CreateVeterinarianPage extends StatefulWidget {
  @override
  _CreateVeterinarianPageState createState() => _CreateVeterinarianPageState();
}

class _CreateVeterinarianPageState extends State<CreateVeterinarianPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String _imageURL = '';

  String username = '';
  String password = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  DateTime? dob;
  String gender = 'Male';
  String specialty = '';
  String workSchedule = '';
  String qualifications = '';
  int yearsExperience = 0;

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      setState(() {
        _image = image;
        _imageURL = url;  // Use this URL in the Image widget
        print("Image picked and URL set: $_imageURL");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text('Create Veterinarian', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageURL.isNotEmpty ? NetworkImage(_imageURL) : AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 20),
              buildTextField('Username', onChanged: (value) => username = value),
              buildTextField('Password', onChanged: (value) => password = value, obscureText: true),
              buildTextField('Email', onChanged: (value) => email = value),
              buildTextField('First Name', onChanged: (value) => firstName = value),
              buildTextField('Last Name', onChanged: (value) => lastName = value),
              buildTextField('Specialty', onChanged: (value) => specialty = value),
              buildTextField('Work Schedule', onChanged: (value) => workSchedule = value),
              buildTextField('Qualifications', onChanged: (value) => qualifications = value),
              buildTextField('Years of Experience', onChanged: (value) => yearsExperience = int.parse(value), keyboardType: TextInputType.number),
              buildDateField(context, 'Date of Birth', _dobController, onChanged: (value) => dob = DateFormat('yyyy-MM-dd').parse(value)),
              buildRadioButtons(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, {required Function(String) onChanged, bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }

  Widget buildDateField(BuildContext context, String label, TextEditingController controller, {required Function(String) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;
            onChanged(formattedDate);
          }
        },
      ),
    );
  }

  Widget buildRadioButtons() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Male'),
          leading: Radio<String>(
            value: 'Male',
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Female'),
          leading: Radio<String>(
            value: 'Female',
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Uint8List? imageBytes = _image != null ? await _image!.readAsBytes() : null;

      Veterinarian newVet = Veterinarian(
        id: 0,
        username: username,
        Password: password,
        email: email,
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        gender: gender,
        specialty: specialty,
        workSchedule: workSchedule,
        qualifications: qualifications,
        yearsExperience: yearsExperience,
        image: imageBytes,
      );

      bool success = await ApiHandler().createVeterinarian(newVet);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veterinarian created successfully!')));
        Navigator.pop(context, newVet);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create veterinarian.')));
      }
    }
  }
}


