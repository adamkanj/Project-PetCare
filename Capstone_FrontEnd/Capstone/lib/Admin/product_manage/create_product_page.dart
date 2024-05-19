import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../ApiHandler.dart'; // Ensure this path is correct
import '../../models/product.dart'; // Ensure this path is correct

class CreateProductPage extends StatefulWidget {
  final ApiHandler apiHandler;

  CreateProductPage({Key? key, required this.apiHandler}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageData;

  // Controllers for the input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController petGenreController = TextEditingController();

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      final Uint8List imageData = await selected.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
    }
  }

  // Function to save a new product
  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      Product newProduct = Product(
        productId: 0,
        name: nameController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text),
        quantity: int.tryParse(quantityController.text),
        category: categoryController.text,
        petGenre: petGenreController.text,
        image: _imageData,
      );

      try {
        await widget.apiHandler.createProduct(newProduct);
        Navigator.pop(context, true); // Return success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create product: $e')),
        );
      }
    }
  }

  // Helper function to create a form field with consistent styling
  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (value) => value!.isEmpty ? 'Please enter a $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text('Add New Product', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(false), // Cancel without creating a product
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageData != null ? MemoryImage(_imageData!) : null,
                  child: _imageData == null ? Icon(Icons.add_a_photo, size: 50) : null,
                ),
              ),
              SizedBox(height: 20),
              buildTextField('Name', nameController),
              buildTextField('Description', descriptionController),
              buildTextField('Price', priceController, keyboardType: TextInputType.number),
              buildTextField('Quantity', quantityController, keyboardType: TextInputType.number),
              buildTextField('Category', categoryController),
              buildTextField('Pet Genre', petGenreController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
