import 'package:flutter/material.dart';
// Product model enhanced with toJson and fromJson (for API integration)
class Product {
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageAsset;
  final int quantityInStock;
  final String petGenre;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageAsset,
    required this.quantityInStock,
    required this.petGenre,
  });
  // Convert a Product into a Map. The keys must correspond to the names of the
  // JSON properties.
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'category': category,
    'imageAsset': imageAsset,
    'quantityInStock': quantityInStock,
    'petGenre': petGenre,
  };

  // A method to create a Product from a Map. This will be useful when consuming data from an API
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json['name'],
    description: json['description'],
    price: json['price'],
    category: json['category'],
    imageAsset: json['imageAsset'],
    quantityInStock: json['quantityInStock'],
    petGenre: json['petGenre'],
  );
}

// Include comments for where to implement API calls
Future<List<Product>> fetchProducts() async {
  // Here, implement your API call to fetch products
  // Example: http.get('https://api.yoursite.com/products');
  // For now, we return empty list
  return [];
}