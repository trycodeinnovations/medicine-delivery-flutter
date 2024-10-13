import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medquick/User/Model/addressmodel.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> orderConfirm(List<Map<String, dynamic>> cartItems, double totalAmount, AddressModel address, String email, BuildContext context) async {
  try {
    // Assuming the user is already logged in or authenticated
    // If you need user registration, you need to include password as well.
    
    // Convert the cartItems to a format that Firestore can handle
    // List<Map<String, dynamic>> products = cartItems.map((item) => {
    //   'name': item['name'],
    //   'quantity': item['quantity'],
    //   'price': item['price'],
    // }).toList();

    // Store order in Firestore under 'orders' collection using email as a document ID
    await firestore.collection("orders").doc(email).set({
      'address': address,
      'products': cartItems,
      'totalAmount': totalAmount,
      'orderDate': FieldValue.serverTimestamp().toString(), // Adds a timestamp
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order confirmed successfully"))
    );
  } catch (e) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order confirmation failed: ${e.toString()}"))
    );
    print(e);
  }
}
