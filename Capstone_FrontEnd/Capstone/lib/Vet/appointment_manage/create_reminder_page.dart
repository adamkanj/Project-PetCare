import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../ApiHandler.dart';
import '../../models/for_vet/appointment.dart';
import '../../IdProvider.dart';

class CreateAppointmentPage extends StatefulWidget {
  @override
  _CreateAppointmentPageState createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDateTime = DateTime.now();
  TextEditingController _petIdController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  late int vetID;

  @override
  void initState() {
    super.initState();
    // Ensure we are listening to the provider in the correct place
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        vetID = Provider.of<IdProvider>(context, listen: false).id!;
      }
    });
  }

  @override
  void dispose() {
    _petIdController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final petId = int.tryParse(_petIdController.text);
        if (petId == null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Invalid pet ID: ${_petIdController.text}'),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
            ),
          );
          return;
        }

        final ownerId = await getPetOwnerId(petId);
        if (ownerId == null || ownerId == -1) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Pet owner ID not found for pet ID: $petId'),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
            ),
          );
          return;
        }

        final newAppointment = Appointment(
          appointmentId: 0,
          vetId: vetID,
          petId: petId,
          ownerId: ownerId,
          description: _descriptionController.text,
          appointmentDate: _selectedDateTime,
          category: _categoryController.text,
          status: _statusController.text,
        );

        await ApiHandler().createAppointment(newAppointment);
        Navigator.pop(context);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create appointment: $e'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
          ),
        );
      }
    }
  }

  Future<int?> getPetOwnerId(int petId) async {
    final String apiUrl = 'https://localhost:7281/api/petowner/owner/$petId';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else if (response.statusCode == 404) {
        return -1; // Indicates pet owner not found
      } else {
        throw Exception('Failed to load pet owner ID');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load pet owner ID: $e'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
        ),
      );
      return null;
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
          _selectedDateTime = DateTime(picked.year, picked.month, picked.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create New Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _petIdController,
                decoration: InputDecoration(labelText: 'Pet ID', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a Pet ID';
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a description';
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a category';
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a status';
                  return null;
                },
              ),
              ListTile(
                title: Text('Date & Time: ${_formatDateTime(_selectedDateTime)}'),
                onTap: () => _selectDateAndTime(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text('Save Appointment')),
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
