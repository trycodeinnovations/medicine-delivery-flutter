import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting the DateTime
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medquick/User/myorders.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  // Format Firestore Timestamp to readable Date format
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy').format(dateTime); // Example: 09 Aug 2024
  }

  // Method to fetch orders based on the user's email
  Stream<QuerySnapshot> getUserOrders() {
    User? user = _auth.currentUser; // Get the currently logged-in user
    if (user != null) {
      // Query Firestore where the email in the address map matches the logged-in user's email
      return FirebaseFirestore.instance
          .collection('orders')
          .where('address.email', isEqualTo: user.email) // Adjusted to match the email field in the address map
          .snapshots();
    } else {
      // Return an empty stream if no user is logged in
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(240, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Orders'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserOrders(), // Fetch user-specific orders
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders available.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              // Convert Firestore Timestamp to formatted string
              String orderDate = formatTimestamp(order['orderDate']);
              // Check the order status
              String orderStatus = order['status'] ?? 'pending'; // Default status is 'pending'

              return Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Column(
                            children: [
                              Text(
                                'Order Date:',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                orderDate, // Display the formatted date
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Column(
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              Text(
                                '${order['totalAmount']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 30,
                      thickness: 2,
                      color: Color.fromARGB(234, 234, 234, 234),
                      endIndent: 0,
                      indent: 0,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(7),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            // Display different statuses based on order status
                            Text(
                              orderStatus == 'canceled'
                                  ? "Order Canceled"
                                  : "Order Confirmed",
                              style: TextStyle(
                                color: orderStatus == 'canceled' ? Colors.red : Colors.green,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Delivery by August 12", // You can replace this with a dynamic delivery date
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 7),
                          IconButton(
                            onPressed: () {
                              String orderId = order.id; // Get the order ID from Firestore document

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyOrders(orderId: orderId), // Pass the order ID
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ],
                      ),
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
