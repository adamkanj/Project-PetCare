import 'package:flutter/material.dart';
import '../models/Equipment.dart';
import '../ApiHandler.dart';
import 'equipment_manage/create_equipment_page.dart';
import 'equipment_manage/update_equipment_page.dart';

class EquipmentManager extends StatefulWidget {
  @override
  _EquipmentManagerState createState() => _EquipmentManagerState();
}

class _EquipmentManagerState extends State<EquipmentManager> {
  List<Equipment> equipments = [];
  List<Equipment> filteredEquipments = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEquipments();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchEquipments() async {
    try {
      equipments = await ApiHandler().fetchEquipments();
      setState(() {
        filteredEquipments = equipments;
      });
    } catch (e) {
      print("Error fetching equipments: $e");
    }
  }

  void _onSearchChanged() {
    setState(() {
      filteredEquipments = equipments.where((equipment) {
        final name = equipment.name?.toLowerCase() ?? '';
        final category = equipment.category?.toLowerCase() ?? '';
        return name.contains(_searchController.text.toLowerCase()) ||
            category.contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text('Manage Equipment', style: TextStyle(color: Colors.white)),
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
                labelText: 'Search by name or category',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEquipments.length,
              itemBuilder: (context, index) {
                return EquipmentCardWidget(
                  equipment: filteredEquipments[index],
                  onUpdate: () => _fetchEquipments(),  // Refresh the list after an update
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEquipmentPage()),
          );
          if (result is Equipment) {
            setState(() {
              equipments.add(result);
              filteredEquipments = equipments;
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class EquipmentCardWidget extends StatelessWidget {
  final Equipment equipment;
  final VoidCallback onUpdate;

  const EquipmentCardWidget({Key? key, required this.equipment, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateEquipmentPage(equipment: equipment),
          ),
        );
        if (result == true) {
          onUpdate();  // Call the onUpdate callback to refresh the list
        }
      },
      child: Card(
        color: Colors.blueGrey,
        child: ListTile(
          title: Text(equipment.name ?? 'Unknown', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Category: ${equipment.category}\nQuantity: ${equipment.quantity}',
            style: TextStyle(color: Colors.white70),
          ),
          trailing: Text('ID: ${equipment.id}', style: TextStyle(color: Colors.white)),
        ),
        margin: EdgeInsets.all(8),
        elevation: 5,
      ),
    );
  }
}
