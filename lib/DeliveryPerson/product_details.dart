import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquick/DeliveryPerson/otp_screen.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  OrderDetailsPage({required this.orderId});

  Future<Map<String, dynamic>?> _fetchOrderDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('orders').doc(orderId).get();
      return doc.data() as Map<String, dynamic>?; 
    } catch (e) {
      print('Error fetching order details: $e');
      return null;
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
  }

  double _calculateTotalAmount(List<dynamic> items) {
    double total = 0.0;
    for (var item in items) {
      double price = item['price']?.toDouble() ?? 0.0; // Ensure price is a double
      int quantity = item['quantity']?.toInt() ?? 0; // Ensure quantity is an int
      total += price * quantity; // Add to total amount
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
        title: Text('Order Details', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: FutureBuilder<Map<String, dynamic>?>( 
          future: _fetchOrderDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No order details available'));
            }

            final orderData = snapshot.data!;
            return ListView(
              children: [
                _buildOrderInfo(orderData),
                SizedBox(height: 16),
                _buildDeliveryAddress(orderData['address']),
                SizedBox(height: 16),
                _buildItemDetails(orderData['items']),
                SizedBox(height: 16),
                _buildTotalAmount(orderData['items']),
                SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OTPVerificationScreen()),
                    );
                  },
                  child: Text(
                    "Confirm Delivery",
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: Size(200, 40),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderInfo(Map<String, dynamic> orderData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Order ID', orderData['doc.orderId']?.toString() ?? 'N/A'),
            _buildRow('Customer Name', orderData['user_name'] ?? 'N/A'),
            _buildRow('Order Type', orderData['paymentMethod'] ?? 'N/A'),
            _buildRow('Date and Time', orderData['orderDate'] is Timestamp ? _formatTimestamp(orderData['orderDate']) : 'N/A'),
            _buildRow('Payment Status', orderData['paymentStatus'] ?? 'N/A'),
            Row(
              children: [
                Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(
                  orderData['status'] ?? 'N/A',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress(Map<String, dynamic> address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Address',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Address Type: ${address['addressType']?.toString() ?? 'N/A'}'),
        SizedBox(height: 10),
        Text('Landmark: ${address['landmark']?.toString() ?? 'N/A'}'),
        SizedBox(height: 10),
        Text('Address: ${address['address']?.toString() ?? 'N/A'}'),
        SizedBox(height: 10),
        Text('Pin Code: ${address['pinCode']?.toString() ?? 'N/A'}'),
        SizedBox(height: 10),
        Text('Mobile Number: ${address['phone']?.toString() ?? 'N/A'}'),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildItemDetails(List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Name", style: TextStyle(fontWeight: FontWeight.w600)),
            Text("Quantity", style: TextStyle(fontWeight: FontWeight.w600)),
            Text("Price", style: TextStyle(fontWeight: FontWeight.w600)), // Add Price header
          ],
        ),
        SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return _buildItemRow(
              items[index]['name'],
              items[index]['quantity']?.toString() ?? '0',
              items[index]['price']?.toString() ?? '0.' // Convert price to String
            );
          },
        ),
      ],
    );
  }

  Widget _buildTotalAmount(List<dynamic> items) {
    double total = _calculateTotalAmount(items);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '₹ ${total.toStringAsFixed(2)}', // Format the total amount to 2 decimal places
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String quantity, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 14),
        ),
        Text(quantity),
        Text('₹ $price'), // Display the price of the item
      ],
    );
  }
}
