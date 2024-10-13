import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquick/User/cod_confirmedscreen.dart';
import 'package:medquick/User/Model/cartmodel.dart' as cart_model; // Alias cartmodel import
import 'package:medquick/User/payment_screen.dart' as payment_screen;

// Assuming CartItem class
class CartItem {
  final String id;
  final String item_name;
  final int quantity;
  final double price;
   final String image;

  CartItem({
    required this.id,
    required this.item_name,
    required this.quantity,
    required this.price,
    required this.image,
  });

  // Convert CartItem to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_name': item_name,
      'quantity': quantity,
      'price': price,
      'image_url':image
    };
  }
}

class PaymentOptionScreen extends StatelessWidget {
  const PaymentOptionScreen({super.key, required this.items, required this.newAddress, required this.totalAmt});
  
  final List<cart_model.CartItem> items; // List of CartItem objects
  final Map<String, dynamic> newAddress; // Assuming the address is a map
  final double totalAmt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 251, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Select Payment Method'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PaymentOptionCard(
              icon: Icons.credit_card,
              title: "Cash on Delivery",
              onTap: () async {
                try {
                  // Convert CartItem list to a list of maps
                  List<Map<String, dynamic>> cartItemsMap = items.map((item) => item.toMap()).toList();

                  // Add order details to Firestore
                  await FirebaseFirestore.instance.collection('orders').add({
                    'items': cartItemsMap, // The list of items as maps
                    'address': newAddress, // The address details
                    'totalAmount': totalAmt, // The total amount
                    'paymentMethod': 'Cash on Delivery', // Payment method
                    'orderDate': Timestamp.now(), // Current timestamp
                  });

                  // Show success dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Order Successful'),
                      content: Text('Your order has been placed successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => orderconfirmed(
                                items: cartItemsMap, 
                                newAddress: newAddress,
                              ),
                            )); // Navigate to order confirmation screen
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  // Handle errors
                  print('Error placing order: $e');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Order Failed'),
                      content: Text('There was an error placing your order. Please try again.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20.0),
            // Other payment options can be added here (Credit/Debit Card, Net Banking, UPI, etc.)
            PaymentOptionCard(
              icon: Icons.credit_card,
              title: 'Credit/Debit Card',
              onTap: () {
                // Navigate to credit card payment screen
              },
            ),
            SizedBox(height: 20.0),
            PaymentOptionCard(
              icon: Icons.payment,
              title: 'Net Banking',
              onTap: () {
                // Navigate to net banking payment screen
              },
            ),
            SizedBox(height: 20.0),
            PaymentOptionCard(
              icon: Icons.payment,
              title: 'UPI',
              onTap: () {
                // Navigate to UPI payment screen
              },
            ),
            SizedBox(height: 70),
            Container(
              child: Image.asset('assets/Image/cards.png'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const PaymentOptionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.0,
              color: Colors.blue,
            ),
            SizedBox(width: 20.0),
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
