import 'package:flutter/material.dart';
import '../../models/for_vet/appointment.dart';
import '../../ApiHandler.dart';
import 'package:intl/intl.dart';

class EditAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  EditAppointmentPage({Key? key, required this.appointment}) : super(key: key);

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _vetIdController;
  late TextEditingController _petIdController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _statusController;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _vetIdController = TextEditingController(text: widget.appointment.vetId?.toString() ?? '');
    _petIdController = TextEditingController(text: widget.appointment.petId?.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.appointment.description ?? '');
    _categoryController = TextEditingController(text: widget.appointment.category ?? '');
    _statusController = TextEditingController(text: widget.appointment.status ?? '');
    _date = widget.appointment.appointmentDate;
  }

  @override
  void dispose() {
    _vetIdController.dispose();
    _petIdController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _updateAppointment() async {
    // Ensure the form is validated before submitting
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create an updated appointment object with the current form values
      final updatedAppointment = Appointment(
        appointmentId: widget.appointment.appointmentId,
        ownerId: widget.appointment.ownerId,
        vetId: int.tryParse(_vetIdController.text),
        petId: int.tryParse(_petIdController.text),
        description: _descriptionController.text,
        appointmentDate: _date,
        category: _categoryController.text,
        status: _statusController.text,
      );

      try {
        // Call the API to update the appointment
        final bool success = await ApiHandler().updateAppointment(
            widget.appointment.appointmentId, updatedAppointment);

        // Check if the update was successful
        if (success) {
          // Notify the user of the successful update
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Appointment updated successfully!'))
          );
          // Close the current screen and pass `true` to indicate success
          Navigator.pop(context, true);
        } else {
          // Notify the user of a failed update
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update appointment.'))
          );
        }
      } catch (e) {
        // Catch any exceptions and show an error message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating appointment: $e'))
        );
      }
    }
  }


  TextEditingController _dateController = TextEditingController();

  void _selectDateAndTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_date),
      );

      if (pickedTime != null) {
        setState(() {
          _date = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text = DateFormat('yyyy-MM-dd – HH:mm').format(_date);
        });
      }
    }
  }

  Future<void> _deleteAppointment() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await ApiHandler().deleteAppointment(widget.appointment.appointmentId);
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Return to previous screen
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Failed to delete appointment: $e'),
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
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _petIdController,
                decoration: InputDecoration(labelText: 'Pet ID'),
                enabled: false, // Disable text editing
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Pet ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a status';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Date & Time: ${_formatDateTime(_date)}'),
                onTap: _selectDateAndTime,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _updateAppointment,
                    child: Text('Submit Changes'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _deleteAppointment,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text('Delete'),
                  ),
                ],
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
