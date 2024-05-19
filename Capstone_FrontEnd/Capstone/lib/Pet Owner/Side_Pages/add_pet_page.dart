import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../APiHandler.dart';
import '../../IdProvider.dart';
import '../../models/for_pet_owner/Ownerpet.dart';
import '../pets_page.dart'; // Adjust as needed

class AddPetPage extends StatefulWidget {
  const AddPetPage({Key? key}) : super(key: key);

  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = bytes;
      });
    }
  }

  Future<void> _addPet() async {
    DateTime? dob;
    try {
      dob = DateTime.parse(_dobController.text);
    } catch (e) {
      print("Error parsing date: $e");
    }

    // Retrieve the owner ID from the provider
    final ownerId = Provider.of<IdProvider>(context, listen: false).id;
    if (ownerId == null) {
      // Handle the case where owner ID is not available
      print('Owner ID not found');
      return;
    }

    // Create the new pet instance
    final newPet = Pet(
      petId: 0, // Placeholder; actual ID will be set by the backend
      ownerId: ownerId,
      name: _nameController.text,
      species: _speciesController.text,
      breed: _breedController.text,
      gender: _genderController.text,
      dob: dob,
      image: _imageData,
    );

    try {
      // Send a request to the backend to add the pet
      final apiHandler = ApiHandler();
      final createdPet = await apiHandler.createPet(newPet);

      // Navigate back to the pets page with the newly added pet
      Navigator.of(context).pop(createdPet);
    } catch (e) {
      print('Error creating pet: $e');
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    image: _imageData != null
                        ? DecorationImage(
                      image: MemoryImage(_imageData!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _imageData == null
                      ? Icon(Icons.photo_camera, size: 50)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Add Pet Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildPetDetailFormField('Name', _nameController),
            _buildPetDetailFormField('Species', _speciesController),
            _buildPetDetailFormField('Gender', _genderController),
            _buildPetDetailFormField('Date of Birth', _dobController),
            _buildPetDetailFormField('Breed', _breedController),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addPet,
                child: Text('Add Pet'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetDetailFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
