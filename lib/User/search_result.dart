import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final String searchQuery;

  SearchResultsPage({required this.searchQuery});

  // Method to fetch products based on search query
  Stream<QuerySnapshot> searchProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('product_name', isGreaterThanOrEqualTo: searchQuery)
        .where('product_name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: searchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading products.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      product['image_url'],
                      height: 80,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8),
                    Text(
                      product['product_name'],
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${product['discount']}% Off",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
