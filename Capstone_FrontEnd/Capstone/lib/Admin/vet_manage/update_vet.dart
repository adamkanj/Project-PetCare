import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../ApiHandler.dart'; // Adjust import path based on your structure
import '../../models/veterinarian.dart';


class UpdateVeterinarianPage extends StatefulWidget {
  final Veterinarian vet;

  UpdateVeterinarianPage({Key? key, required this.vet}) : super(key: key);

  @override
  _UpdateVeterinarianPageState createState() => _UpdateVeterinarianPageState();
}

class _UpdateVeterinarianPageState extends State<UpdateVeterinarianPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;

  // Attributes
  late String username;
  late String password;
  late String email;
  late String firstName;
  late String lastName;
  DateTime? dob;
  late String gender;
  late String specialty;
  late String workSchedule;
  late String qualifications;
  late int yearsExperience;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    username = widget.vet.username;
    email = widget.vet.email;
    firstName = widget.vet.firstName ?? '';
    lastName = widget.vet.lastName ?? '';
    dob = widget.vet.dob;
    gender = widget.vet.gender ?? 'Male';
    specialty = widget.vet.specialty ?? '';
    workSchedule = widget.vet.workSchedule ?? '';
    qualifications = widget.vet.qualifications ?? '';
    yearsExperience = widget.vet.yearsExperience ?? 0;

    if (dob != null) {
      _dobController.text = DateFormat('yyyy-MM-dd').format(dob!);
    }

    // Use existing image data
    _imageData = widget.vet.image;
    if (_imageData != null) {
      print("Loaded image data of length: ${_imageData?.length}");
    } else {
      print("No image data loaded.");
    }
  }

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      print("New image picked: ${selected.path}");  // Debug: print new image path

      // Read the image data into memory
      var imageData = await selected.readAsBytes();
      print("Image data length: ${imageData.length}");  // Debug: print image data length

      setState(() {
        _imageData = imageData;
      });
    }
  }


  Widget buildTextField(String label, String initialValue, Function(String) onChanged, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        initialValue: initialValue,
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

  Widget buildDateField(BuildContext context, String label, TextEditingController controller, Function(String) onChanged) {
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
            initialDate: dob ?? DateTime.now(),
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

  void _updateVeterinarian() async {
    if (_formKey.currentState!.validate()) {
      Veterinarian updatedVet = Veterinarian(
        id: widget.vet.id,
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        gender: gender,
        specialty: specialty,
        workSchedule: workSchedule,
        qualifications: qualifications,
        yearsExperience: yearsExperience,
        phoneNumber: widget.vet.phoneNumber,
        image: _imageData,  // Use the modified image data
      );

      bool success = await ApiHandler().updateVeterinarian(widget.vet.id, updatedVet);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veterinarian updated successfully!')));
        Navigator.pop(context, updatedVet);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update veterinarian.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text('Update Veterinarian', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
                  backgroundImage: _imageData != null ? MemoryImage(_imageData!) : AssetImage('assets/default_avatar.png') as ImageProvider,
                  child: _imageData == null ? Icon(Icons.add_a_photo, size: 50) : null,
                ),
              ),
              SizedBox(height: 20),
              buildTextField('Username', username, (value) => username = value),
              buildTextField('Email', email, (value) => email = value),
              buildTextField('First Name', firstName, (value) => firstName = value),
              buildTextField('Last Name', lastName, (value) => lastName = value),
              buildTextField('Specialty', specialty, (value) => specialty = value),
              buildTextField('Work Schedule', workSchedule, (value) => workSchedule = value),
              buildTextField('Qualifications', qualifications, (value) => qualifications = value),
              buildTextField('Years of Experience', yearsExperience.toString(), (value) => yearsExperience = int.tryParse(value) ?? 0, keyboardType: TextInputType.number),
              buildDateField(context, 'Date of Birth', _dobController, (value) {
                dob = DateFormat('yyyy-MM-dd').parse(value);
              }),
              buildRadioButtons(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateVeterinarian,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
