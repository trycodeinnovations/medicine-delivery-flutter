import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> profileGet() async {
  try {
    String? email = FirebaseAuth.instance.currentUser!.email;
    print(email);

    // Get the document from Firestore
    var update = FirebaseFirestore.instance.collection("users").doc(email);
    DocumentSnapshot<Map<String, dynamic>> querySnapshot = await update.get();

    // Print the document data
    if (querySnapshot.exists) {
      Map<String, dynamic>? data = querySnapshot.data();
      // print(data);

      if (data != null) {
        notificationsData = {
          
          'firstname': data['firstname'],
          'lastname': data['lastname'],
          'phone': data['phone'],
          'email':data['email'],
        };
      }

      print(notificationsData);
    } else {
      print("No such document!");
    }
  } catch (e) {
    print("Exception: $e");
  }
}

Map<String, dynamic> notificationsData = {};
