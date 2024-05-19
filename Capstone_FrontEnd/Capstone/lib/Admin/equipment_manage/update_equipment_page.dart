import 'package:flutter/material.dart';
import '../../models/Equipment.dart';
import '../../ApiHandler.dart';
import 'package:intl/intl.dart';

class UpdateEquipmentPage extends StatefulWidget {
  final Equipment equipment;

  UpdateEquipmentPage({Key? key, required this.equipment}) : super(key: key);

  @override
  _UpdateEquipmentPageState createState() => _UpdateEquipmentPageState();
}

class _UpdateEquipmentPageState extends State<UpdateEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _quantityController;

  // Create TextEditingController for date fields
  TextEditingController _lastScanDateController = TextEditingController();
  TextEditingController _nextScanDateController = TextEditingController();

  DateTime? _lastScanDate;
  DateTime? _nextScanDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment.name ?? '');
    _categoryController = TextEditingController(text: widget.equipment.category ?? '');
    _quantityController = TextEditingController(text: widget.equipment.quantity?.toString() ?? '');

    // Initialize the date fields if the equipment has dates
    _lastScanDate = widget.equipment.lastScanDate;
    if (_lastScanDate != null) {
      _lastScanDateController.text = DateFormat('yyyy-MM-dd').format(_lastScanDate!);
    }

    _nextScanDate = widget.equipment.nextScanDate;
    if (_nextScanDate != null) {
      _nextScanDateController.text = DateFormat('yyyy-MM-dd').format(_nextScanDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text('Update Equipment', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              buildTextField('Name', _nameController),
              buildTextField('Category', _categoryController),
              buildTextField('Quantity', _quantityController, keyboardType: TextInputType.number),
              buildDateField(context, 'Last Scan Date', _lastScanDateController, (date) {
                _lastScanDate = date;
              }),
              buildDateField(context, 'Next Scan Date', _nextScanDateController, (date) {
                _nextScanDate = date;
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEquipment,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Widget buildDateField(BuildContext context, String label, TextEditingController controller, Function(DateTime) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,  // Make the text field read-only
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            onChanged(pickedDate);
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
      ),
    );
  }

  void _updateEquipment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Equipment updatedEquipment = Equipment(
        id: widget.equipment.id,
        name: _nameController.text,
        category: _categoryController.text,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        lastScanDate: _lastScanDate,
        nextScanDate: _nextScanDate,
      );

      bool success = await ApiHandler().updateEquipment(updatedEquipment);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Equipment updated successfully!')));
        Navigator.pop(context, true); // Indicate success and refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update equipment.')));
      }
    }
  }
}
