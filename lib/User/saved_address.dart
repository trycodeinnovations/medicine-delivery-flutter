import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedAddressesPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  // Method to fetch addresses where email matches the logged-in user's email
  Stream<QuerySnapshot> getUserAddresses() {
    User? user = _auth.currentUser; // Get the currently logged-in user
    if (user != null) {
      // Query Firestore where the email in addresses matches the logged-in user's email
      return _firestore
          .collection('addresses')
          .where('email', isEqualTo: user.email)
          .snapshots();
    } else {
      // Return an empty stream if no user is logged in
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Saved addresses',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 1),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getUserAddresses(), // Fetch user-specific addresses
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error loading addresses"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // If no addresses are found
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No saved addresses found."),
                  );
                }

                // If addresses are found, display them in a ListView
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var addressData = snapshot.data!.docs[index];

                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.home_outlined, size: 35),
                        title: Text(
                          addressData['user_name'], // Name of the person
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${addressData['addressType']}, ${addressData['address']} - ${addressData['landmark']}, ${addressData['pinCode']}", // Display formatted address
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            // Handle options like edit, delete
                            if (value == 'edit') {
                              // Handle edit functionality
                            } else if (value == 'delete') {
                              // Handle delete functionality
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

