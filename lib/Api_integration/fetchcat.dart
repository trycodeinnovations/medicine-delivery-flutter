import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCategoryAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all categories from Firestore
  Stream<List<Map<String, dynamic>>> fetchCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'name': doc['name'], // Category name
          'imageUrl': doc['imageUrl'], // Category image URL
        };
      }).toList();
    });
  }
}
