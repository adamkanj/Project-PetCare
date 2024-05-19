import 'package:flutter/material.dart';
import '../models/product.dart';

// Cart Page
class CartPage extends StatelessWidget {
  final List<String> cartItems;

  CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.transparent,
        // Set the AppBar background to transparent
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index]),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                // Action to remove the item from the cart
                cartItems.removeAt(index); // Update this to use state management if needed
                (context as Element).reassemble();
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              print('Proceed to checkout');
            },
            child: Text('Proceed to Checkout', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              // Set the AppBar background to transparent
              elevation: 0, // Replace 'primary' with 'backgroundColor'
            ),
          ),
        ),
      ),
    );
  }
}
