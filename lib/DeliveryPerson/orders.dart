// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:medquick/DeliveryPerson/home.dart';
//  // Import the new screen

// class Orders extends StatefulWidget {
//   const Orders({super.key});

//   @override
//   State<Orders> createState() => _OrdersState();
// }

// class _OrdersState extends State<Orders> {
//   // Fetch all orders from Firestore
//   Stream<QuerySnapshot> fetchOrders() {
//     return FirebaseFirestore.instance.collection('orders').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//         title: Text("Orders"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: fetchOrders(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Text('No orders available', style: TextStyle(fontSize: 16)),
//             );
//           }

//           final orders = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final orderData = orders[index].data() as Map<String, dynamic>;
//               final address = orderData['address'] as Map<String, dynamic>?;

//               String fullAddress = "";
//               if (address != null) {
//                 fullAddress = "${address['address']}, ${address['landmark']}, ${address['pinCode']}";
//               } else {
//                 fullAddress = 'No address available';
//               }

//               return Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Card(
//                   elevation: 4,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Order Id: ${orders[index].id}",
//                                     style: TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.location_on, size: 16),
//                                       SizedBox(width: 8),
//                                       Expanded(
//                                         child: Text(
//                                           fullAddress,
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 3,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.shopping_bag, size: 16),
//                                       SizedBox(width: 8),
//                                       Expanded(
//                                         child: Text(
//                                           "Items: ${(orderData['items'] as List).join(', ')}",
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 7,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () {
//                                 // Navigate to OrderDetailScreen and pass order ID
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => HomeScreen(orderId: orders[index].id),
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 "Accept",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 // Handle order rejection
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.redAccent,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 "Reject",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
