import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';

class MyOrders extends StatelessWidget {
  final String orderId;
  MyOrders({required this.orderId});

  // Fetch order details from Firestore
  Future<DocumentSnapshot> fetchOrderDetails(String orderId) {
    return FirebaseFirestore.instance.collection('orders').doc(orderId).get();
  }

  // Cancel the order by updating its status in Firestore
  Future<void> cancelOrder(String orderId) async {
    try {
      // Update the 'status' field in the order document to 'canceled'
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'canceled',
      });
    } catch (e) {
      print("Failed to cancel order: $e");
      throw e; // You can show a snackbar or dialog if something goes wrong
    }
  }

  // Show confirmation dialog before canceling the order
  Future<void> showCancelConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // The user must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this order?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                // If the user confirms, cancel the order
                await cancelOrder(orderId);
                Navigator.of(context).pop(); // Dismiss the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order canceled successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchOrderDetails(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Order not found"));
          }

          var orderData = snapshot.data!.data() as Map<String, dynamic>;
          var items = List<Map<String, dynamic>>.from(orderData['items']);

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Delivery Date Section
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Color.fromARGB(255, 244, 244, 244),
                leading: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                title: Text(
                  "Delivery by",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text("August 12"),
              ),
              SizedBox(height: 16),

              // Address Section
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Color.fromARGB(255, 244, 244, 244),
                leading: Icon(Icons.home_outlined, color: Colors.grey, size: 30),
                title: Text("Deliver to", style: TextStyle(color: Colors.grey)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderData['address']['addressType'] ?? "N/A",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(orderData['address']['address'] ?? "N/A"),
                      Text(orderData['address']['landmark'] ?? "N/A"),
                      Text(orderData['address']['pinCode'] ?? "N/A"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Shipment Items Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Shipment Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 8),

              // List of Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['imageUrl'] ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item['name'] ?? 'N/A',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Qty: ${item['quantity'].toString() ?? '1'}"),
                        trailing: Text(
                          "₹ ${item['price'].toStringAsFixed(2)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 30,
                      thickness: 1,
                      color: Color(0xFFDCDCDC),
                      endIndent: 16,
                      indent: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Cancel Order Section
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: const Color.fromARGB(255, 244, 244, 244),
                leading: Text(
                  "Cancel order",
                  style: TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  onPressed: () {
                    // Show the confirmation dialog before canceling the order
                    showCancelConfirmation(context);
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
              SizedBox(height: 10),

              // Payment Summary Section
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  "Payment Summary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
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
                            Text("₹ ${orderData['totalAmount'].toStringAsFixed(2)}"),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Discount", style: TextStyle(color: Colors.grey)),
                            Text("- ₹ 5.35"), // Replace with dynamic discount if available
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Shipping Fee", style: TextStyle(color: Colors.grey)),
                            Text("+ ₹ 20.00"), // Replace with dynamic shipping fee if available
                          ],
                        ),
                        SizedBox(height: 15),
                        DottedLine(dashColor: Colors.grey),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Bill Amount", style: TextStyle(color: Colors.grey)),
                            Text(
                              "₹ ${orderData['totalAmount'].toStringAsFixed(2)}",
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
                          color: Color(0xFFC9F3CA),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Saving", style: TextStyle(color: Colors.green)),
                                Text(
                                  "₹ 5.35", // Replace with dynamic savings if available
                                  style: TextStyle(
                                      color: Colors.green, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
