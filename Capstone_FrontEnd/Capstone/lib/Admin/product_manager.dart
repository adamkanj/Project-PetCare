// screens/product_manager.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../ApiHandler.dart'; // Adjust to match your API handler location
import 'product_manage/create_product_page.dart';
import 'product_manage/update_product_page.dart';

class ProductManager extends StatefulWidget {
  @override
  _ProductManagerState createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  final ApiHandler apiHandler = ApiHandler(); // Make sure ApiHandler is in the right directory

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(() {
      filterProducts();
    });
  }

  Future<void> fetchProducts() async {
    try {
      products = await apiHandler.getAllProducts(); // Adjust method name as needed
      setState(() {
        filteredProducts = products;
      });
    } catch (e) {
      print('Failed to fetch products: $e');
    }
  }

  void filterProducts() {
    var lowerCaseQuery = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        return product.name!.toLowerCase().contains(lowerCaseQuery) ||
            product.category!.toLowerCase().contains(lowerCaseQuery) ||
            product.petGenre!.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text('Manage Products', style: TextStyle(color: Colors.white)),
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
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCardWidget(
                  product: filteredProducts[index],
                  onUpdate: fetchProducts,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProductPage(apiHandler: apiHandler)),
          );
          if (created != null) {
            fetchProducts(); // Refresh the product list after creating a new product
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreenAccent,
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final Function onUpdate;

  const ProductCardWidget({Key? key, required this.product, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateProductPage(product: product),
          ),
        );
        if (updated) {
          onUpdate(); // Call the onUpdate function to refresh the list
        }
      },
      child: Card(
        color: Colors.lightGreen,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: product.image != null ? MemoryImage(product.image!) : AssetImage('assets/default_avatar.png') as ImageProvider,
            child: product.image == null ? Icon(Icons.image, color: Colors.white) : null,
          ),
          title: Text(product.name ?? 'No Name', style: TextStyle(color: Colors.white)),
          subtitle: Text(
              'Price: \$${product.price?.toStringAsFixed(2) ?? "No Price"}\nQuantity: ${product.quantity ?? "No Quantity"} items',
              style: TextStyle(color: Colors.white70)),
          trailing: Text('ID: ${product.productId}', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
