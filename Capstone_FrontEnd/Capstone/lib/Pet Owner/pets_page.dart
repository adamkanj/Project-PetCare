import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../APiHandler.dart';
import '../IdProvider.dart';
import 'side_pages/add_pet_page.dart';
import 'side_pages/pet_details_page.dart';
import '../models/for_pet_owner/Ownerpet.dart';

class PetsPage extends StatefulWidget {
  PetsPage({Key? key}) : super(key: key);

  @override
  _PetsPageState createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  List<Pet> pets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  /// Fetches the list of pets for the current owner from the API
  Future<void> _loadPets() async {
    final ownerId = Provider.of<IdProvider>(context, listen: false).id ?? 0;
    try {
      final petsJsonList = await ApiHandler().getPetsByOwnerId(ownerId);
      List<Pet> parsedPets = petsJsonList.map<Pet>((json) => Pet.fromJson(json)).toList();
      setState(() {
        pets = parsedPets;
      });
    } catch (e) {
      print('Error fetching pets: $e');
    }
  }

  /// Navigates to the PetDetailsPage and checks if an update occurred
  void _navigateAndUpdatePets(BuildContext context, Pet pet) async {
    final updatedPet = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailsPage(pet: pet)),
    );

    if (updatedPet != null && updatedPet is Pet) {
      // Find and update the pet in the list
      int index = pets.indexWhere((p) => p.petId == updatedPet.petId);
      if (index != -1) {
        setState(() {
          pets[index] = updatedPet;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Your Pets',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _buildHorizontalPetList(),
            _buildVerticalPetCards(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedPet = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPetPage()),
          );
          if (addedPet != null) {
            _loadPets(); // Reload the list of pets after adding a new pet
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHorizontalPetList() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                  pets[index].image != null ? MemoryImage(pets[index].image!) : null,
                  child: pets[index].image == null
                      ? Icon(Icons.pets, size: 50, color: Colors.grey)
                      : null,
                ),
                SizedBox(height: 5),
                Text(
                  pets[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalPetCards() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _navigateAndUpdatePets(context, pets[index]),
          child: Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pets[index].image != null
                      ? Image.memory(
                    pets[index].image!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.pets, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    pets[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.transgender, size: 20, color: Colors.black54),
                              SizedBox(width: 10),
                              Text('Gender: ${pets[index].gender}'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.pets, size: 20, color: Colors.black54),
                              SizedBox(width: 10),
                              Text('Breed: ${pets[index].breed}'),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.category, size: 20, color: Colors.black54),
                              SizedBox(width: 10),
                              Text('Species: ${pets[index].species}'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.cake, size: 20, color: Colors.black54),
                              SizedBox(width: 10),
                              Text('DOB: ${pets[index].dob?.toIso8601String().split('T').first}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _navigateAndUpdatePets(context, pets[index]),
                    child: Text('View Profile'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
