import 'package:flutter/material.dart';
import '../../models/for_pet_owner/Ownerpet.dart';
import '../../models/for_vet/MedicalRecord.dart';
import 'edit_pet_details_page.dart';
import '../../ApiHandler.dart';

class PetDetailsPage extends StatefulWidget {
  final Pet pet;

  PetDetailsPage({Key? key, required this.pet}) : super(key: key);

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> with SingleTickerProviderStateMixin {
  late Pet _pet;
  late TabController _tabController;
  Future<List<MedicalRecord>>? _medicalRecordsFuture;

  @override
  void initState() {
    super.initState();
    _pet = widget.pet;
    _tabController = TabController(length: 2, vsync: this);
    _loadMedicalRecords();
  }

  void _loadMedicalRecords() {
    if (_pet.petId != null) {
      _medicalRecordsFuture = ApiHandler().getAllMedicalRecordsByPetId(_pet.petId);
    } else {
      // Handle null petId, maybe set a local error message
      print("Error: Pet ID is null");
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pet.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _navigateAndDisplayUpdate(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: _pet.image != null
                    ? DecorationImage(
                  image: MemoryImage(_pet.image!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: _pet.image == null ? Center(child: Icon(Icons.pets, size: 80, color: Colors.grey[500])) : null,
            ),
            SizedBox(height: 20),
            Text('Name: ${_pet.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildDetailRow(Icons.transgender, 'Gender: ${_pet.gender ?? "Unknown"}'),
            _buildDetailRow(Icons.category, 'Species: ${_pet.species ?? "Unknown"}'),
            _buildDetailRow(Icons.pets, 'Breed: ${_pet.breed ?? "Unknown"}'),
            _buildDetailRow(Icons.cake, 'DOB: ${_pet.dob?.toIso8601String().split('T').first ?? "Unknown"}'),
            SizedBox(height: 20),
            _buildMedicalRecordsSection(),
          ],
        ),
      ),
    );
  }

  // Widget _buildPetImageSection() {
  //   return Container(
  //     height: 200,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.grey[200],
  //       borderRadius: BorderRadius.circular(8),
  //       image: _pet.image != null
  //           ? DecorationImage(
  //         image: MemoryImage(_pet.image!),
  //         fit: BoxFit.cover,
  //       )
  //           : null,
  //     ),
  //     child: _pet.image == null ? Center(child: Icon(Icons.pets, size: 80, color: Colors.grey[500])) : null,
  //   );
  // }

  // Widget _buildPetDetails() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       children: [
  //         Text('Name: ${_pet.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //         _buildDetailRow(Icons.transgender, 'Gender: ${_pet.gender ?? "Unknown"}'),
  //         _buildDetailRow(Icons.category, 'Species: ${_pet.species ?? "Unknown"}'),
  //         _buildDetailRow(Icons.pets, 'Breed: ${_pet.breed ?? "Unknown"}'),
  //         _buildDetailRow(Icons.cake, 'DOB: ${_pet.dob?.toIso8601String().split('T').first ?? "Unknown"}'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMedicalRecordsSection() {
    return Container(
      child: Column(
        children: [
          Text('Medical Records', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            height: 300,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Pending"),
                    Tab(text: "Complete"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _medicalStatusView('Pending'),
                      _medicalStatusView('Complete'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _medicalStatusView(String status) {
    return FutureBuilder<List<MedicalRecord>>(
      future: _medicalRecordsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Failed to load records: ${snapshot.error}"));
        } else if (snapshot.data != null && snapshot.data!.isEmpty) {
          return Center(child: Text("No records for $status"));
        } else if (snapshot.hasData) {
          List<MedicalRecord> filteredRecords = snapshot.data!
              .where((record) => record.status == status)
              .toList();
          return ListView(
            children: filteredRecords.map((record) => _buildMedicalRecordCard(record)).toList(),
          );
        } else {
          return Center(child: Text("No medical records found"));
        }
      },
    );
  }



  Widget _buildMedicalRecordCard(MedicalRecord record) {
    return Card(
      elevation: 4, // Adds a subtle shadow to the card
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12), // Increased padding for better visual spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.service ?? "Unknown Service",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              record.description ?? "No description provided",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Date: ${record.date?.toIso8601String().split('T').first ?? "Unknown date"}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _navigateAndDisplayUpdate(BuildContext context) async {
    final updatedPet = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPetDetailsPage(pet: _pet)),
    );

    if (updatedPet != null) {
      setState(() {
        _pet = updatedPet;
      });
      Navigator.pop(context, updatedPet);
    }
  }
}
