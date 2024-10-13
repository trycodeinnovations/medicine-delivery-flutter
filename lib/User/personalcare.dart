import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquick/User/productScreen.dart'; // Import the product screen

class PersonalcareScreen extends StatelessWidget {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

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
        title: Text('Personal Care'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Essential Personal Care',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: productsRef
                    .where('category', isEqualTo: 'R5B6Z1lCnCBIdygZRsHM') // Fetch only Support Aid products
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading products'));
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products found'));
                  }

                  var medicines = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: medicines.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.65, // Adjusted for image prominence
                    ),
                    itemBuilder: (context, index) {
                      var product = medicines[index];
                      
                      String productId = product.id; // Get the product ID
                      String imageUrl = product['image_url'] ?? '';
                      String productName = product['product_name'] ?? 'Unknown Product';
                      String discount = product['discount']?.toString() ?? '0%';
                      String price = product['price']?.toString() ?? '0';
                      String originalPrice = product['old_price']?.toString() ?? price;

                      return MedicineCard(
                        image: imageUrl,
                        name: productName,
                        discount: discount,
                        price: price,
                        originalPrice: originalPrice,
                        productId: productId, // Pass product ID
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
  final String image;
  final String name;
  final String discount;
  final String price;
  final String originalPrice;
  final String productId; // Product ID passed to the details page

  const MedicineCard({
    required this.image,
    required this.name,
    required this.discount,
    required this.price,
    required this.originalPrice,
    required this.productId, // Add the product ID parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5, // Increased elevation for better shadow effect
      shadowColor: Colors.grey.withOpacity(0.5), // Softer shadow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  height: 160, // Increased height for better visibility
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '$discount% OFF', // Discount as a percentage
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹ $price', // Current price with currency
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '₹ $originalPrice', // Original price with strikethrough
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Pass the product ID to the ProductDetailsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(productId: productId),
                      ),
                    );
                  },
                  child: Text('View'),
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
}
