import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';  // Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart';    // Firebase Firestore


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload Image to Firebase Storage
  Future<String> uploadImageToStorage(File image) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Unique file name
      final storageRef = _storage.ref().child('categories/$fileName'); // Reference to Firebase Storage path
      UploadTask uploadTask = storageRef.putFile(image); // Upload file
      TaskSnapshot snapshot = await uploadTask; // Wait for the upload to complete
      String downloadUrl = await snapshot.ref.getDownloadURL(); // Get the download URL
      return downloadUrl; // Return the download URL of the image
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  // Add category name and image URL to Firestore
  Future<void> addCategoryToFirestore(String name, String imageUrl) async {
    try {
      await _firestore.collection('categories').add({
        'name': name,         // Category name
        'imageUrl': imageUrl, // Image URL from Firebase Storage
      });
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // Combined method to upload image and add category to Firestore
  Future<void> addCategoryWithImage(File image, String namecontroller) async {
    print('processing');
    try {
      // Step 1: Upload image and get URL
      String imageUrl = await uploadImageToStorage(image);

      // Step 2: Add category name and image URL to Firestore
      await addCategoryToFirestore(namecontroller, imageUrl);
    } catch (e) {
      throw Exception('Failed to add category with image: $e');
    }
  }

