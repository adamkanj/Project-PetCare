import 'package:flutter/material.dart';
import '../../APiHandler.dart';
import '../../models/for_vet/MedicalRecord.dart';
import '../../models/for_vet/vet_pet.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class MedicalRecordsPage extends StatefulWidget {
  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  late Future<List<Vet_Pet>> _petsFuture;
  List<Vet_Pet> _allPets = [];
  List<Vet_Pet> _filteredPets = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _petsFuture = ApiHandler().fetchPets();
    _searchController.addListener(_filterPets);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPets() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredPets = query.isEmpty
          ? _allPets // No filtering when the search query is empty
          : _allPets
          .where((pet) =>
      pet.name.toLowerCase().contains(query) ||
          pet.id.toString().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Records'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or ID',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Vet_Pet>>(
        future: _petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load pets: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final pets = snapshot.data!;
            if (_allPets.isEmpty) {
              _allPets = pets;
              _filteredPets = pets;
            }

            return ListView.builder(
              itemCount: _filteredPets.length,
              itemBuilder: (context, index) {
                final pet = _filteredPets[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: pet.imageUrl != null ? MemoryImage(pet.imageUrl!) : const AssetImage("assets/default_pet.png") as ImageProvider,
                    ),
                    title: Text(pet.name),
                    subtitle: Text("${pet.breed}, owned by ${pet.ownerName}"),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicalRecordsDetailsPage(pet: pet),  // Make sure this class name is correct
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No pets found"));
          }
        },
      ),
    );
  }
}


class MedicalRecordsDetailsPage extends StatefulWidget {
  final Vet_Pet pet;

  MedicalRecordsDetailsPage({required this.pet});

  @override
  _MedicalRecordsDetailsPageState createState() => _MedicalRecordsDetailsPageState();
}

class _MedicalRecordsDetailsPageState extends State<MedicalRecordsDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<MedicalRecord>>? _medicalRecordsFuture;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
    _reloadMedicalRecords();
  }

  void _reloadMedicalRecords() {
    setState(() {
      _medicalRecordsFuture = ApiHandler().getAllMedicalRecordsByPetId(widget.pet.id);
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  Widget _medicalStatusView(String status) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sorting: ${_sortAscending ? "Oldest to Newest" : "Newest to Oldest"}'),
              ElevatedButton(
                onPressed: _toggleSortOrder,
                child: Text(_sortAscending ? 'Sort Newest to Oldest' : 'Sort Oldest to Newest'),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<MedicalRecord>>(
            future: _medicalRecordsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Failed to load records: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                List<MedicalRecord> filteredRecords = snapshot.data!
                    .where((record) => record.status == status)
                    .toList();

                if (filteredRecords.isEmpty) {
                  return Center(child: Text("No records for $status"));
                }

                filteredRecords.sort((a, b) {
                  if (a.date == null || b.date == null) return 0;
                  return _sortAscending
                      ? a.date!.compareTo(b.date!)
                      : b.date!.compareTo(a.date!);
                });

                return ListView.builder(
                  itemCount: filteredRecords.length,
                  itemBuilder: (context, index) {
                    final MedicalRecord record = filteredRecords[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.service ?? "Unknown service",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              record.description ?? "No description",
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Administered On: ${record.date?.toString().split(' ')[0] ?? 'Unknown'}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () async {
                                bool updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateMedicalRecordPage(medicalRecord: record),
                                  ),
                                ) ?? false;
                                if (updated) {
                                  _reloadMedicalRecords();
                                }
                              },
                              child: Text('Update'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text("No medical records found"));
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pet.name} Medical Records'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Complete"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _medicalStatusView('Pending'),
          _medicalStatusView('Complete'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMedicalRecordPage(petId: widget.pet.id),
            ),
          ) ?? false;
          if (updated) {
            _reloadMedicalRecords();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class CreateMedicalRecordPage extends StatefulWidget {
  final int petId;

  CreateMedicalRecordPage({required this.petId});

  @override
  _CreateMedicalRecordPageState createState() => _CreateMedicalRecordPageState();
}

class _CreateMedicalRecordPageState extends State<CreateMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _serviceController = TextEditingController();
  DateTime? _dateAdministered;
  String _status = 'Pending';
  List<Uint8List>? _testResults;

  // Function to convert files to base64 strings
  List<String>? _encodeFiles(List<Uint8List>? files) {
    return files?.map((file) => base64Encode(file)).toList();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'RecordId': 0,
        'PetId': widget.petId,
        'Description': _descriptionController.text,
        'Service': _serviceController.text,
        'TestResults': _encodeFiles(_testResults),  // Encode the files to base64 strings
        'Date': _dateAdministered?.toIso8601String(),
        'Status': _status,
      };

      try {
        bool success = await ApiHandler().createMedicalRecord(data);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Medical record created')));
          Navigator.pop(context, true); // Return true to indicate the list needs refreshing
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create record')));
        }
      } catch (e) {
        print('Error creating medical record: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Please try again later.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Medical Record for ${widget.petId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceController,
                decoration: InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20), // Add spacing
              TextFormField(
                controller: _descriptionController,
                maxLines: 5, // Enlarge the description input field
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description here...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20), // Add spacing
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Pending', 'Complete'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              SizedBox(height: 20), // Add spacing
              ListTile(
                title: Text(_dateAdministered == null ? 'Date Administered' : 'Administered On: ${_dateAdministered!.toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _dateAdministered ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _dateAdministered = picked);
                  }
                },
              ),
              SizedBox(height: 20), // Add spacing
              if (_testResults != null)
                Text('Files selected: ${_testResults!.length}'),
              SizedBox(height: 20), // Add spacing
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class UpdateMedicalRecordPage extends StatefulWidget {
  final MedicalRecord medicalRecord;
  UpdateMedicalRecordPage({required this.medicalRecord});

  @override
  _UpdateMedicalRecordPageState createState() => _UpdateMedicalRecordPageState();
}

class _UpdateMedicalRecordPageState extends State<UpdateMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _serviceController;
  DateTime? _date;
  late String _status;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.medicalRecord.description);
    _serviceController = TextEditingController(text: widget.medicalRecord.service);
    _date = widget.medicalRecord.date;
    _status = widget.medicalRecord.status ?? 'Pending';
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'RecordId': widget.medicalRecord.recordId,
        'PetId': widget.medicalRecord.petId,
        'Description': _descriptionController.text,
        'Service': _serviceController.text,
        'TestResults': widget.medicalRecord.testResults,
        'Date': _date?.toIso8601String(),
        'Status': _status,
      };

      bool success = await ApiHandler().updateMedicalRecord(widget.medicalRecord.recordId, data);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Medical record updated')));
        Navigator.pop(context, true); // Pop with 'true' to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update record')));
      }
    }
  }

  Future<void> _deleteRecord() async {
    bool success = await ApiHandler().deleteMedicalRecord(widget.medicalRecord.recordId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Medical record deleted')));
      Navigator.pop(context, true);  // Pop with 'true' to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete medical record')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Medical Record'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteRecord,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceController,
                decoration: InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20), // Add spacing
              TextFormField(
                controller: _descriptionController,
                maxLines: 5, // Enlarge the description input field
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description here...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20), // Add spacing
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Pending', 'Complete'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              SizedBox(height: 20), // Add spacing
              ListTile(
                title: Text(_date == null ? 'Date' : 'On: ${_date!.toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              SizedBox(height: 20), // Add spacing
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


