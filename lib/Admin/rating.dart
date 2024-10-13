import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medquick/Admin/home.dart';

class AdminUserRatingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: UserRatingScreen(),
    );
  }
}

class UserRatingScreen extends StatelessWidget {
  // Fetch user ratings from Firestore
  Stream<QuerySnapshot> fetchUserRatings() {
    return FirebaseFirestore.instance.collection('rating').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Ratings'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Adhome(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Ratings Overview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: fetchUserRatings(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return  const Center(
                          child: Text(
                            'No ratings available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      // Get the rating documents from Firestore
                      final userRatings = snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                        final DateTime date = timestamp.toDate();

                        return {
                          'email': data['email'] ?? 'Unknown Email',
                          'rating': data['rating'] ?? 0.0,
                          'review': data['review'] ?? 'No review',
                          'timestamp': DateFormat.yMMMd().add_jm().format(date),
                        };
                      }).toList();

                      // Display the ratings in a DataTable
                      return DataTable(
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Rating',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Review',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                        rows: userRatings
                            .map(
                              (user) => DataRow(
                                cells: [
                                  DataCell(Text(user['email'])),
                                  DataCell(
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          user['rating'].toString(),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(user['review'])),
                                  DataCell(Text(user['timestamp'])),
                                ],
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
