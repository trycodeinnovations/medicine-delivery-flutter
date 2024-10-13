import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // Navigate back
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Color.fromARGB(255, 255, 255, 255),
          child: ListTile(
            title: const Text('Delete Account'),
            onTap: () async {
              await _deleteAccount(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      // Get the currently logged-in user
      User? user = _auth.currentUser;
      
      if (user != null) {
        // Fetch the user's email
        String userEmail = user.email ?? "";

        // Reference to the Firestore collection where user data is stored
        CollectionReference usersCollection = _firestore.collection('users');

        // Find and delete the user's document in Firestore based on their email
        await usersCollection
            .where('email', isEqualTo: userEmail)
            .get()
            .then((snapshot) async {
          for (var doc in snapshot.docs) {
            await doc.reference.delete();
          }
        });

        // Optionally, sign out the user after deleting the account
        await _auth.signOut();

        // Show a success message and navigate away
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account deleted successfully')),
        );

        // Navigate to the login or home screen
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user logged in')),
        );
      }
    } catch (e) {
      // Handle any errors during deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }
}
