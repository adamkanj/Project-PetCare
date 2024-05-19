import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_reviews_page.dart';

// Define a theme color variable, ensure it's accessible in your settings
const Color kPrimaryColor = Colors.deepPurple;
const Color kAccentColor = Colors.deepOrange;

class ProductDetailPage extends StatelessWidget {
  final Product product;

  ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'), // Use consistent theme color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            product.image != null
                ? Image.memory(
              product.image!,
              height: 250, // Fixed height for consistency
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 128, color: Colors.grey);
              },
            )
                : Image.asset('assets/placeholder.jpeg', height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name ?? "No name available", style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(product.description ?? "No description available", style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 10),
                  Text('Price: \$${product.price?.toStringAsFixed(2) ?? 'N/A'}', style: TextStyle(color: kAccentColor, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Category: ${product.category ?? 'N/A'}'),
                  SizedBox(height: 5),
                  Text('Quantity in Stock: ${product.quantity?.toString() ?? 'N/A'}'),
                  SizedBox(height: 5),
                  Text('Pet Genre: ${product.petGenre ?? 'N/A'}'),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductReviewsPage(product: product)),
                        );
                      },
                      child: Text('View Reviews'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent, // Use backgroundColor instead of primary
                        foregroundColor: Colors.white, // Use foregroundColor instead of onPrimary
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
