// models/product.dart
import 'dart:typed_data'; // For handling images as byte data

class Product {
  final int productId;
  String? name;
  String? description;
  double? price;
  int? quantity;
  String? category;
  String? petGenre;
  Uint8List? image; // Handling the image as bytes

  Product({
    required this.productId,
    this.name,
    this.description,
    this.price,
    this.quantity,
    this.category,
    this.petGenre,
    this.image,
  });
}