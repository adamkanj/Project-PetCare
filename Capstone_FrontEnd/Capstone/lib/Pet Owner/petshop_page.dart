import 'package:flutter/material.dart';
import '../models/product.dart'; // Ensure the path to the Product model is correct
import 'product_detail_page.dart';
import 'cart_page.dart';
import '../../ApiHandler.dart'; // Ensure this path matches your project structure

class PetShopPage extends StatefulWidget {
  const PetShopPage({Key? key}) : super(key: key);

  @override
  State<PetShopPage> createState() => _PetShopPageState();
}

class _PetShopPageState extends State<PetShopPage> {
  List<String> cartItems = [];
  List<Product> products = [];
  String filter = 'All';
  String searchQuery = '';
  final ApiHandler apiHandler = ApiHandler();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var fetchedProducts = await apiHandler.getAllProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Failed to fetch products: $e');
    }
  }

  void updateFilter(String newFilter) {
    setState(() {
      filter = newFilter;
    });
    fetchProducts();
  }

  void searchProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Pet Shop',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: searchProducts,
                decoration: InputDecoration(
                  hintText: 'Search for products',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            _buildFilterButtons(),
            _buildProductList(),
          ],
        ),
      ),
      backgroundColor: Colors.white10,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => CartPage(cartItems: cartItems)),
      //     );
      //   },
      //   child: Icon(Icons.shopping_cart),
      // ),
    );
  }

  Widget _buildFilterButtons() {
    List<String> categories = ['All', 'Dogs', 'Cats', 'Fish', 'Birds', 'Reptiles'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: FilterChip(
              label: Text(category),
              selected: filter == category,
              onSelected: (bool selected) {
                updateFilter(selected ? category : 'All');
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.orangeAccent,
              showCheckmark: false,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(color: filter == category ? Colors.white : Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductList() {
    // This method filters the products based on the current filter and search query
    List<Product> filteredProducts = products.where((product) {
      bool matchesFilter = filter == 'All' || product.petGenre == filter;
      bool matchesSearch = searchQuery.isEmpty || product.name!.toLowerCase().contains(searchQuery);
      return matchesFilter && matchesSearch;
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
            );
          },
          child: _buildProductCard(product),
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(6),  // Reduced margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,  // Keeps proportion but gives more space if necessary
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: product.image != null ? Image.memory(
                product.image!,
                fit: BoxFit.cover,
              ) : Image.asset(
                'assets/placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),  // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,  // Reduces extra spacing
              children: [
                Text(
                  product.name ?? "Unnamed Product",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),  // Potentially reduced font size
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.description ?? "No description available.",
                  style: TextStyle(fontSize: 12),  // Reduced font size
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),  // Reduced spacing
                Text(
                  '\$${product.price?.toStringAsFixed(2) ?? 'N/A'}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),  // Adjusted font size
                ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {
                //       setState(() {
                //         cartItems.add(product.name!);  // Ensure 'name' is not null before adding
                //       });
                //     },
                //     child: Text('Add to Cart', style: TextStyle(fontSize: 12)),  // Reduced font size on button
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
