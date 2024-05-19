import 'package:flutter/material.dart';
import 'dart:async';
import '../ApiHandler.dart'; // Adjust path to ApiHandler class as necessary
import '../models/veterinarian.dart'; // Adjust path as necessary
import 'Side_Pages/profile_page.dart';
import 'Side_Pages/notifications_page.dart';
import 'vet_manage/create_vet.dart';
import 'vet_manage/update_vet.dart';

class VetManager extends StatefulWidget {
  @override
  _VetManagerState createState() => _VetManagerState();
}

class _VetManagerState extends State<VetManager> {
  final TextEditingController _searchController = TextEditingController();
  List<Veterinarian> veterinarians = [];
  List<Veterinarian> filteredVeterinarians = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchAndStoreVeterinarians();
  }

  void _fetchAndStoreVeterinarians() async {
    try {
      ApiHandler apiHandler = ApiHandler(); // Create an instance of ApiHandler
      List<Veterinarian> vets = await apiHandler.fetchVeterinarians();
      setState(() {
        veterinarians = vets;
        filteredVeterinarians = vets;
      });
    } catch (e) {
      print('Error fetching veterinarians: $e');
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredVeterinarians = veterinarians.where((vet) {
        bool matchesFirstName = vet.firstName?.toLowerCase().contains(query) ?? false;
        bool matchesLastName = vet.lastName?.toLowerCase().contains(query) ?? false;
        return matchesFirstName || matchesLastName;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('VET Management', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredVeterinarians.length,
              itemBuilder: (context, index) {
                return VetCardWidget(
                  vet: filteredVeterinarians[index],
                  onUpdate: () => navigateAndUpdateVeterinarian(filteredVeterinarians[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // After adding a new veterinarian, refresh the list
          var newVet = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateVeterinarianPage()),
          );

          if (newVet != null) {
            _fetchAndStoreVeterinarians();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }

  void navigateAndUpdateVeterinarian(Veterinarian vet) async {
    var updatedVet = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateVeterinarianPage(vet: vet),
      ),
    );

    if (updatedVet != null) {
      setState(() {
        // Find and update the veterinarian in the list
        int index = veterinarians.indexWhere((element) => element.id == updatedVet.id);
        if (index != -1) {
          veterinarians[index] = updatedVet;
          // Re-filter to update the view
          _onSearchChanged();
        }
      });
    }
  }
}

class VetCardWidget extends StatelessWidget {
  final Veterinarian vet;
  final VoidCallback onUpdate;

  const VetCardWidget({Key? key, required this.vet, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onUpdate,
      child: Card(
        color: Colors.blueAccent,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: vet.image != null && vet.image!.isNotEmpty
                ? MemoryImage(vet.image!)
                : NetworkImage('https://via.placeholder.com/150') as ImageProvider,
          ),
          title: Text(
            '${vet.firstName ?? "No First Name"} ${vet.lastName ?? "No Last Name"}',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Email: ${vet.email}\nSpecialty: ${vet.specialty ?? "N/A"}',
            style: TextStyle(color: Colors.white70),
          ),
          trailing: Text(
            'ID: ${vet.id}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
