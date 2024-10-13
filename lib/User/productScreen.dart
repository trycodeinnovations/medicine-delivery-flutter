import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquick/User/Model/cartmodel.dart';
import 'package:medquick/User/cart_screen.dart';

// Assume this is your cart instance, in a real-world scenario you would have a provider or state management solution for this
Cart cart = Cart();

class ProductDetailsPage extends StatelessWidget {
  final String productId; // Accept product ID
 

  // Constructor
  ProductDetailsPage({Key? key, required this.productId,}) : super(key: key);

  ValueNotifier<bool> isAddedToCart = ValueNotifier(false);
  ValueNotifier<int> quantity = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: const Text('Product Details'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Fetch product details from Firestore
        future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading product details'));
          } else if (!snapshot.data!.exists) {
            return Center(child: Text('Product not found'));
          }

          var productData = snapshot.data!.data() as Map<String, dynamic>; // Cast to map

          return ListView(
            children: [
              Container(
                height: 300,
                child: Center(
                  child: Image.network(
                    productData['image_url'] ?? 'https://via.placeholder.com/150', // Fetch the image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(style: BorderStyle.none),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Color.fromARGB(255, 172, 225, 220),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              productData['product_name'] ?? 'Unknown Product', // Fetch the product name
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                            ),
                            Text(
                              "₹ ${productData['price']?.toString() ?? '0.00'}", // Fetch the price
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.teal),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text(
                          "Description",
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          productData['description'] ?? 'No description available', // Fetch the description
                          style: TextStyle(color: Color.fromARGB(255, 81, 81, 76)),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: ValueListenableBuilder(
                          valueListenable: quantity,
                          builder: (BuildContext context, value, Widget? child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Total:",
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "₹ ${(productData['price'] ?? 0) * quantity.value}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        quantity.value++;
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.add, color: Colors.white),
                                        backgroundColor: Colors.teal,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "${quantity.value.toString()}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        if (quantity.value > 1) {
                                          quantity.value--;
                                        }
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.remove, color: Colors.white),
                                        backgroundColor: Colors.teal,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 70),
                      ValueListenableBuilder(
                        valueListenable: isAddedToCart,
                        builder: (BuildContext context, value, Widget? child) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 39.0),
                              child: InkWell(
                                onTap: () {
                                  if (!isAddedToCart.value) {
                                    addToCart(productData);
                                    isAddedToCart.value = true;
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CheckoutScreen()),
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.teal,
                                  ),
                                  height: 50,
                                  width: 350,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          isAddedToCart.value ? "GO TO CART" : "ADD TO CART",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void addToCart(Map<String, dynamic> productData) {
    // Add item to local cart
    cart.addItem(CartItem(
      id: productId, // Use the product ID for the CartItem
      item_name: productData['product_name'] ?? 'Unknown Product',
      price: productData['price']?.toDouble() ?? 0.0,
      quantity: quantity.value,
      imageUrl: productData['image_url'] ?? 'assets/Image/logo2.png',
    ));

    // Upload the cart item to Firestore
    uploadToFirestore(CartItem(
      id: productId,
      item_name: productData['product_name'] ?? 'Unknown Product',
      price: productData['price']?.toDouble() ?? 0.0,
      quantity: quantity.value,
      imageUrl: productData['image_url'] ?? 'assets/Image/logo2.png',
    ));
  }

  Future<void> uploadToFirestore(CartItem item) async {
    var emaill=FirebaseAuth.instance.currentUser!.email;
    try {
      // Reference to the Firestore collection named 'cart'
      CollectionReference cartCollection = FirebaseFirestore.instance.collection('cart');
      // Add item to the collection
      await cartCollection.add({
        'productId': item.id,
        'name': item.item_name,
        'price': item.price,
        'quantity': item.quantity,
        'imageUrl': item.imageUrl,
        'email': emaill, // Add email to Firestore document
      });
      print("Item added to cart collection successfully!");
    } catch (e) {
      print("Error adding item to cart: $e");
    }
  }
}
