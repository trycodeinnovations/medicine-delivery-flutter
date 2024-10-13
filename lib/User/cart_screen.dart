import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:medquick/User/addres_screen.dart';
import 'package:medquick/User/Model/cartmodel.dart'; // Ensure this is correctly imported

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double deliveryFee = 20.35;
  double discount = 5.35;
  List<CartItem> cartItems = []; // List to hold fetched cart items
  User? currentUser; // To store the current logged-in user

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // Fetch the logged-in user
  }

  // Fetch the currently logged-in user
  void fetchCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Fetch cart items after the user is available
      await fetchCartItems();
    }
  }

  Future<void> fetchCartItems() async {
    try {
      if (currentUser == null) return; // Ensure the user is logged in

      // Fetch cart items only for the logged-in user's email
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('email', isEqualTo: currentUser!.email)
          .get();

      setState(() {
        cartItems = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return CartItem(
            id: doc.id,
            item_name: data['name'],
            price: data['price'],
            quantity: data['quantity'],
            imageUrl: data['imageUrl'],
          );
        }).toList();
      });
    } catch (e) {
      print("Error fetching cart items: $e");
    }
  }

  Future<void> deleteCartItem(String productId) async {
    try {
      // Delete the item from Firestore
      await FirebaseFirestore.instance.collection('cart').doc(productId).delete();
      print("Product deleted successfully");
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 251, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Checkout'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cartItems.isEmpty
            ? Center(
                child: Text(
                  "Add items to your cart, Your cart is empty",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 237, 210),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping_outlined),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Item will be delivered by Saturday, 10 August',
                            style: TextStyle(color: Colors.orange[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Image.network(
                                  item.imageUrl, // Use network image for fetched items
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.item_name,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '₹${item.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (item.quantity > 1) {
                                            item.quantity--;
                                          }
                                        });
                                      },
                                    ),
                                    Text(item.quantity.toString()),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          item.quantity++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    // Call delete function and update state
                                    await deleteCartItem(item.id); // Pass the product ID to delete
                                    setState(() {
                                      cartItems.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Payment Summary",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("MRP Total", style: TextStyle(color: Colors.grey)),
                              Text("₹${calculateTotalPrice().toStringAsFixed(2)}"),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Discount", style: TextStyle(color: Colors.grey)),
                              Text("- ₹${discount.toStringAsFixed(2)}"),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delivery Fee", style: TextStyle(color: Colors.grey)),
                              Text("+ ₹${deliveryFee.toStringAsFixed(2)}"),
                            ],
                          ),
                          SizedBox(height: 15),
                          const DottedLine(dashColor: Colors.grey),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Bill Amount", style: TextStyle(color: Colors.grey)),
                              Text(
                                "₹${(calculateTotalPrice() + deliveryFee - discount).toStringAsFixed(2)}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Color.fromARGB(255, 201, 243, 202),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Total Saving",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "₹${discount.toStringAsFixed(2)} ",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAddressScreen(
                            items: cartItems,
                            totalAmt: calculateTotalPrice() + deliveryFee - discount,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'Select Address',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
