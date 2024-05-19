// models/product.dart
import 'dart:convert';
import 'dart:typed_data';

class Product {
  final int productId;
  String? name;
  String? description;
  double? price;
  int? quantity;
  String? category;
  String? petGenre;
  Uint8List? image;

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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] ,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      category: json['category'] ?? '',
      petGenre: json['petGenre'] ?? '',
      // Handle image decoding if needed
      image: (json['image'] != null && json['image'].isNotEmpty) ? base64Decode(json['image']) : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'petGenre': petGenre,
      'image': image != null ? base64Encode(image!) : null, // Encode image to base64 if not null
    };
  }

}
