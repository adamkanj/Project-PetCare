import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/product.dart'; // Adjust the path
import '../../APiHandler.dart'; // Adjust the path accordingly

class UpdateProductPage extends StatefulWidget {
  final Product product;

  UpdateProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final ApiHandler apiHandler = ApiHandler(); // Import and initialize your API handler
  Uint8List? _imageData;

  // Controllers for product attributes
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController petGenreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with existing product data
    var product = widget.product;
    nameController.text = product.name ?? "";
    descriptionController.text = product.description ?? "";
    priceController.text = product.price?.toString() ?? "";
    quantityController.text = product.quantity?.toString() ?? "";
    categoryController.text = product.category ?? "";
    petGenreController.text = product.petGenre ?? "";
    _imageData = product.image;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
    }
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      // Collect updated product information
      final updatedProduct = Product(
        productId: widget.product.productId,
        name: nameController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text),
        quantity: int.tryParse(quantityController.text),
        category: categoryController.text,
        petGenre: petGenreController.text,
        image: _imageData,
      );

      // Call the API and handle the result
      final success = await apiHandler.updateProduct(widget.product.productId!, updatedProduct);

      // Provide user feedback
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated successfully!')));
        Navigator.pop(context, true); // Pass a true value to indicate successful update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update product.')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text('Update Product', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
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
                onPressed: _updateProduct,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Common buildTextField function for easier reuse
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
        validator: (value) => value!.isEmpty ? 'Please enter a $label' : null,
      ),
    );
  }
}
