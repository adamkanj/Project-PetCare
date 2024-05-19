import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../../APiHandler.dart';
import '../../models/for_pet_owner/Ownerpet.dart';


class EditPetDetailsPage extends StatefulWidget {
  final Pet pet;

  EditPetDetailsPage({Key? key, required this.pet}) : super(key: key);

  @override
  _EditPetDetailsPageState createState() => _EditPetDetailsPageState();
}

class _EditPetDetailsPageState extends State<EditPetDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _dobController;
  Uint8List? _imageData;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _genderController = TextEditingController(text: widget.pet.gender);
    _speciesController = TextEditingController(text: widget.pet.species);
    _breedController = TextEditingController(text: widget.pet.breed);
    _dobController = TextEditingController(text: widget.pet.dob?.toIso8601String().split('T').first);
    _imageData = widget.pet.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _updatePetDetails() async {
    // Update pet details in the backend
    DateTime? dob;
    try {
      dob = DateTime.parse(_dobController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid date format. Please enter the date as YYYY-MM-DD.")),
      );
      return;
    }

    // Create a new pet instance with updated values
    Pet updatedPet = Pet(
      petId: widget.pet.petId,
      ownerId: widget.pet.ownerId,
      name: _nameController.text,
      species: _speciesController.text,
      breed: _breedController.text,
      gender: _genderController.text,
      dob: dob,
      image: _imageData?? null,
    );

    // Call API to update the pet
    bool success = await ApiHandler().updatePet(widget.pet.petId, updatedPet);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pet details updated successfully!")),
      );
      Navigator.pop(context, updatedPet); // Pop with `true` if you need to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update pet details.")),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.pet.name}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _imageData != null
                      ? MemoryImage(_imageData!)
                      : AssetImage('assets/default_image.png') as ImageProvider,
                  child: _imageData == null ? Icon(Icons.camera_alt, color: Colors.white70, size: 30) : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: _speciesController,
                decoration: InputDecoration(labelText: 'Species'),
              ),
              TextField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Breed'),
              ),
              TextField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.pet.dob ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _dobController.text = pickedDate.toIso8601String().split('T').first;
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePetDetails,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
