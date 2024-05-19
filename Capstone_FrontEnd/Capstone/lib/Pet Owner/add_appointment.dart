import 'package:flutter/material.dart';
import '../../ApiHandler.dart';
import '../../models/veterinarian.dart';
import '../../models/for_vet/appointment.dart';
import 'package:petcare/IdProvider.dart';
import 'package:provider/provider.dart';
import '../models/for_pet_owner/Ownerpet.dart'; // Ensure this import is correct

class AppointmentBookingPage extends StatefulWidget {
  final String serviceName;

  const AppointmentBookingPage({Key? key, required this.serviceName}) : super(key: key);

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDateTime = DateTime.now();
  List<Veterinarian> vets = [];
  List<Pet> pets = [];
  int? selectedVetId;
  int? selectedPetId;

  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVets();
    fetchPets();
  }

  Future<void> fetchVets() async {
    try {
      vets = await ApiHandler().fetchVeterinarians();
      if (vets.isNotEmpty) {
        setState(() {
          selectedVetId = vets.first.id;
        });
      }
    } catch (e) {
      print('Failed to fetch vets: $e');
    }
  }

  Future<void> fetchPets() async {
    int ownerId = Provider.of<IdProvider>(context, listen: false).id!;
    try {
      final response = await ApiHandler().getPetsByOwnerId(ownerId);
      List<Pet> fetchedPets = List<Pet>.from(response.map((model) => Pet.fromJson(model)));
      setState(() {
        pets = fetchedPets;
      });
    } catch (e) {
      print('Failed to fetch pets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Service: ${widget.serviceName}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: selectedVetId,
                decoration: InputDecoration(labelText: 'Select Vet', border: OutlineInputBorder()),
                onChanged: (int? newValue) => setState(() => selectedVetId = newValue),
                items: vets.map<DropdownMenuItem<int>>((Veterinarian vet) => DropdownMenuItem<int>(
                  value: vet.id, child: Text('${vet.firstName} ${vet.lastName}'),
                )).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: selectedPetId,
                decoration: InputDecoration(labelText: 'Select Pet', border: OutlineInputBorder()),
                onChanged: (int? newValue) => setState(() => selectedPetId = newValue),
                items: pets.map<DropdownMenuItem<int>>((Pet pet) => DropdownMenuItem<int>(
                  value: pet.petId, child: Text(pet.name),
                )).toList(),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                leading: Icon(Icons.calendar_today),
                title: Text('Date & Time: ${_selectedDateTime.toString()}'),
                onTap: () => _selectDateAndTime(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                onPressed: () => _formKey.currentState!.validate() ? submitAppointment() : null,
                child: Text('Save Appointment', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        int minute = pickedTime.minute;
        // Round the minute to the nearest valid value (00 or 30)
        minute = (minute / 30).round() * 30;
        if (minute == 60) {
          minute = 0;
          pickedTime.hour == 23 ? pickedDate.add(Duration(days: 1)) : pickedDate;
        }

        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            minute,
          );
        });
      }
    }
  }


  void submitAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (selectedPetId == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please select a pet.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      int providerId = Provider.of<IdProvider>(context, listen: false).id!;

      Appointment newAppointment = Appointment(
        appointmentId: 0,  // Or null if your backend accepts it
        vetId: selectedVetId!,
        petId: selectedPetId,
        ownerId: providerId,
        description: _descriptionController.text,
        appointmentDate: _selectedDateTime,
        category: widget.serviceName,
        status: 'Pending',
      );

      print("Sending request to create appointment with payload: ${newAppointment.toJson()}");

      try {
        await ApiHandler().createAppointment(newAppointment);
        Navigator.pop(context);
      } catch (e) {
        print("Failed to create appointment with error: $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create appointment: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
