import 'package:flutter/material.dart';
import '../../ApiHandler.dart';
import '../../models/for_vet/appointment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateAppointmentPage extends StatefulWidget {
  @override
  _CreateAppointmentPageState createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDateTime = DateTime.now();
  TextEditingController _vetIdController = TextEditingController();
  TextEditingController _petIdController = TextEditingController();
  TextEditingController _ownerIdController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  late int vetID;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _vetIdController.dispose();
    _petIdController.dispose();
    _ownerIdController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Parse petId
        final petId = int.tryParse(_petIdController.text);

        // Check if petId is valid
        if (petId == null) {
          // Handle case when petId is not valid
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Invalid pet ID: ${_petIdController.text}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        // Fetch the pet owner ID
        final ownerId = await getPetOwnerId(petId);

        if (ownerId == null) {
          // Handle case when pet owner ID is not found
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Pet owner ID not found for pet ID: $petId'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        // Prepare appointment object
        final newAppointment = Appointment(
          appointmentId: 0,
          vetId: int.tryParse(_vetIdController.text),
          petId: int.tryParse(_petIdController.text),
          ownerId: ownerId,
          description: _descriptionController.text,
          appointmentDate: _selectedDateTime,
          category: _categoryController.text,
          status: _statusController.text,
        );

        // Call the create appointment function from API handler
        await ApiHandler().createAppointment(newAppointment);

        // Appointment created successfully, navigate back to previous screen
        Navigator.pop(context);
      } catch (e) {
        // Handle error case
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create appointment: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<int> getPetOwnerId(int petId) async {
    final String apiUrl = 'https://localhost:7281/api/petowner/owner/$petId';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode >= 200 && response.statusCode < 210) {
        // If server returns an OK response, parse the JSON
        return int.parse(response.body);
      }
      else {
        throw Exception('Failed to load pet owner');
      }

  }



  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Appointment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _vetIdController,
                decoration: InputDecoration(
                  labelText: 'Vet ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Pet ID';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _petIdController,
                decoration: InputDecoration(
                  labelText: 'Pet ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Pet ID';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a status';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Date & Time: ${_formatDateTime(_selectedDateTime)}'),
                onTap: () => _selectDateAndTime(context),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.toString().split(' ')[0]} ${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }
}
