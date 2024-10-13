import 'package:flutter/material.dart';
import 'package:medquick/DeliveryPerson/product_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  GoogleMapController? _mapController;
  final LatLng _currentDeliveryLocation = LatLng(37.7749, -122.4194); // Example coordinates

  void _launchMaps(String address) async {
    final String url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello! Micheal"),
        backgroundColor: Color.fromARGB(43, 165, 207, 241),
        actions: const [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // StreamBuilder to fetch orders from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('orders').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No orders available', style: TextStyle(fontSize: 16)),
                    );
                  }

                  final orders = snapshot.data!.docs; // List of orders from Firestore

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final orderData = orders[index].data() as Map<String, dynamic>;
                      String orderId = orders[index].id;

                      // Check the structure of the orderData
                      print(orderData); // Debugging line

                      // Assuming address might be a Map. Adjust accordingly.
                      String address = orderData['address'] is Map
                          ? '${orderData['address']['address']}, ${orderData['address']['landmark']}' // Adjust keys
                          : orderData['address'] ?? 'No address available';

                      return Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order Id: $orderId", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16),
                                  SizedBox(width: 8),
                                  Expanded(child: Text(address)),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderDetailsPage(orderId: orderId), // Pass orderId here
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text("Details", style: TextStyle(color: Colors.white)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _launchMaps(address);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text("Direction", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 16),
              Card(
                color: Colors.blue.shade900,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet, color: Colors.white, size: 40),
                          SizedBox(width: 20),
                          Text(
                            "₹ 4251.56",
                            style: TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text("Today", style: TextStyle(color: Colors.white)),
                              Text("₹1520.54", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Text("This Week", style: TextStyle(color: Colors.white)),
                              Text("₹11020.29", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Text("This Month", style: TextStyle(color: Colors.white)),
                              Text("₹28221.66", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.blue.shade300,
                      child: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text("15", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            Text("Today's Orders", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Card(
                      color: Colors.purple.shade300,
                      child: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text("55", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            Text("This Week Orders", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Container(
                width: 355,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.teal.shade700,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text("35", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("Total Orders", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
