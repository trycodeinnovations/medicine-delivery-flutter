import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquick/Admin/edit.dart'; // Import your EditProductScreen

class Inspect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Inspect'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('products').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final medicines = snapshot.data!.docs;
                  return GridView.builder(
                    itemCount: medicines.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final medicine = medicines[index].data() as Map<String, dynamic>;
                      final productId = medicines[index].id; // Get the product ID

                      return MedicineCard(
                        productId: productId, // Pass the product ID
                        image: medicine['image_url'] ?? 'https://via.placeholder.com/150', // Placeholder image for null values
                        name: medicine['product_name'] ?? 'Unknown Medicine',
                        discount: medicine['discount']?.toString() ?? '0%', // Ensure discount is a String
                        price: medicine['price']?.toString() ?? '₹0', // Ensure price is a String
                        originalPrice: medicine['old_price']?.toString() ?? '₹0', // Ensure originalPrice is a String
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String productId; // Added productId
  final String image;
  final String name;
  final String discount;
  final String price;
  final String originalPrice;

  const MedicineCard({
    required this.productId, // Accept productId as a parameter
    required this.image,
    required this.name,
    required this.discount,
    required this.price,
    required this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(image, fit: BoxFit.cover, height: 100, width: double.infinity),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  color: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(
                    '$discount %OFF',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹$price',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '₹$originalPrice',
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    navigateToEditProduct(context, productId); // Pass productId to the navigation method
                  },
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigation method to the EditProductScreen
  void navigateToEditProduct(BuildContext context, String productId) {
    if (productId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductScreen(productsId: productId), // Pass productId to EditProductScreen
        ),
      );
    } else {
      print("Invalid product ID");
    }
  }
}
