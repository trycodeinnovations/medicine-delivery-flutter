import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Order Model
class Order {
  final String orderId;
  final String userAddress;
  final double totalAmount;
  final List<String> items;
  String? assignedDeliveryBoy;
  final String status; // New field for order status

  Order({
    required this.orderId,
    required this.userAddress,
    required this.totalAmount,
    required this.items,
    this.assignedDeliveryBoy,
    required this.status, // Add status as a required field
  });

  // Factory method to create an Order from Firestore Document
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    String address;
    if (data['address'] is Map<String, dynamic>) {
      address = '${data['address']['address']}, ${data['address']['landmark']}, ${data['address']['pinCode']}';
    } else {
      address = data['address'] ?? '';
    }

    return Order(
      orderId: doc.id,
      userAddress: address,
      totalAmount: (data['totalAmount'] is double)
          ? data['totalAmount']
          : double.tryParse(data['totalAmount'].toString()) ?? 0.0,
      items: (data['items'] is List)
          ? List<String>.from(data['items'].map((item) => item.toString()))
          : [],
      assignedDeliveryBoy: data['assignedDeliveryBoy'] as String?,
      status: data['status'] ?? 'Pending', // Fetch status, default to 'Pending' if not provided
    );
  }
}


// Delivery Boy Model
class DeliveryBoy {
  final String name;
  final String phone;
  final String email;

  DeliveryBoy({required this.name, required this.phone, required this.email});

  // Factory method to create a DeliveryBoy from Firestore Document
  factory DeliveryBoy.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeliveryBoy(
      name: data['name'],
      phone: data['phone'],
      email: data['email'], // Fetch email from Firestore
    );
  }
}

class AdminOrderScreen extends StatefulWidget {
  @override
  _AdminOrderScreenState createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  // Fetch delivery boys from Firestore
  Future<List<DeliveryBoy>> fetchDeliveryBoys() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('deliveryBoys').get();
    return querySnapshot.docs.map((doc) => DeliveryBoy.fromFirestore(doc)).toList();
  }

  // Dialog to assign a delivery boy to an order
  // Dialog to assign a delivery boy to an order
// Dialog to assign a delivery boy to an order
Future<void> assignDeliveryBoyDialog(Order order) async {
  DeliveryBoy? selectedDeliveryBoy;

  // Fetch delivery boys from Firestore
  List<DeliveryBoy> deliveryBoys = await fetchDeliveryBoys();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Assign Delivery Boy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: deliveryBoys.map((boy) {
            return RadioListTile<DeliveryBoy>(
              title: Text(boy.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${boy.email}'),
                  Text('Phone: ${boy.phone}'),
                ],
              ),
              value: boy,
              groupValue: selectedDeliveryBoy,
              onChanged: (DeliveryBoy? value) {
                setState(() {
                  selectedDeliveryBoy = value;
                });
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (selectedDeliveryBoy != null) {
                setState(() {
                  order.assignedDeliveryBoy = selectedDeliveryBoy!.email;
                });

                // Update the assigned delivery boy's email in the orders collection
                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(order.orderId)
                    .update({
                  'assignedDeliveryBoy': selectedDeliveryBoy!.email,
                });

                // Update the delivery boy's document with the assigned order
                final deliveryBoyDoc = FirebaseFirestore.instance
                    .collection('deliveryBoys')
                    .doc(selectedDeliveryBoy!.email); // Using email as the document ID

                await deliveryBoyDoc.update({
                  'assignedOrders': FieldValue.arrayUnion([order.orderId])
                });

                Navigator.of(context).pop();
              }
            },
            child: Text('Assign'),
          ),
        ],
      );
    },
  );
}



  // UI for displaying each order
  Widget orderCard(Order order) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 5,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: ${order.orderId}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.shopping_bag, color: Colors.grey),
              SizedBox(width: 5),
              Expanded(child: Text('Items: ${order.items.join(', ')}', style: TextStyle(fontSize: 14))),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey),
              SizedBox(width: 5),
              Expanded(child: Text('Address: ${order.userAddress}', style: TextStyle(fontSize: 14))),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.green),
              SizedBox(width: 5),
              Text('Total Amount: ₹${order.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.assignment, color: Colors.grey),
              SizedBox(width: 5),
              Text('Order Status: ${order.status}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Assigned Delivery Boy: ${order.assignedDeliveryBoy ?? 'Not Assigned'}',
            style: TextStyle(
              fontSize: 14,
              color: order.assignedDeliveryBoy == null ? Colors.red : Colors.green,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.person_add, color: Colors.white),
              label: Text('Assign Delivery Boy', style: TextStyle(color: Colors.white)),
              onPressed: () => assignDeliveryBoyDialog(order),
            ),
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Manage Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders available', style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          // Convert Firestore documents to Order objects
          final orders = snapshot.data!.docs.map((doc) => Order.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return orderCard(orders[index]);
            },
          );
        },
      ),
    );
  }
}


