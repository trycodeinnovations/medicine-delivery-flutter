import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  // Delete image from Firestore and Firebase Storage
  Future<void> _deleteImage(String docId, String fileName) async {
    try {
      // Delete image from Firebase Storage
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
      await firebaseStorageRef.delete();

      // Delete image from Firestore
      await FirebaseFirestore.instance.collection('offerbanners').doc(docId).delete();

      print('Deleted image: $fileName');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  // Upload image to Firebase Storage and save URL to Firestore
  Future<void> _uploadImages() async {
    setState(() {
      _isUploading = true;
    });

    for (var image in _images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');

      try {
        // Upload the image file to Firebase Storage
        await firebaseStorageRef.putFile(image);

        // Get the download URL
        String downloadUrl = await firebaseStorageRef.getDownloadURL();

        // Save the download URL to Firestore in a collection called "offerbanners"
        await FirebaseFirestore.instance.collection('offerbanners').add({
          'url': downloadUrl,
          'file_name': fileName,
        });

        print('Upload complete: $fileName');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    setState(() {
      _isUploading = false;
      _images.clear(); // Optionally clear the image list after upload
    });
  }

  // Stream to fetch uploaded images from Firestore
  Stream<QuerySnapshot> _fetchUploadedImages() {
    return FirebaseFirestore.instance.collection('offerbanners').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.upload, color: Colors.white),
            onPressed: _isUploading ? null : _uploadImages,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.teal, // Text and icon color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              onPressed: _pickImage,
              icon: Icon(Icons.add_a_photo),
              label: Text('Select Image'),
            ),
          ),
          if (_isUploading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Uploading...", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _fetchUploadedImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading images.'));
                }

                final docs = snapshot.data?.docs ?? [];

                return docs.isEmpty
                    ? Center(child: Text('No images uploaded.', style: TextStyle(fontSize: 16)))
                    : GridView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          var doc = docs[index];
                          var imageUrl = doc['url'];
                          var fileName = doc['file_name'];
                          var docId = doc.id;

                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : Center(child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _deleteImage(docId, fileName),
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
