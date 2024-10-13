import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore import
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage for image
import 'package:path/path.dart';  // For handling file paths

class UploadProductScreen extends StatefulWidget {
  @override
  _UploadProductScreenState createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  File? _selectedImage;
  String? _selectedCategory;
  List<DropdownMenuItem<String>> _categoryItems = [];

  // Controllers for form fields
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Function to fetch categories from Firestore
  Future<void> _fetchCategories() async {
    try {
      // Fetch categories from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();

      // Convert fetched data into dropdown menu items
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem(
          child: Text(doc['name']),
          value: doc.id,  // Store the document ID as the value
        );
      }).toList();

      setState(() {
        _categoryItems = items;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  // Function to upload the product to Firestore
  Future<void> _uploadProduct() async {
    if (_selectedImage == null || _selectedCategory == null || _productNameController.text.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields and select an image')));
      return;
    }

    try {
      // Show loading indicator
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploading product...')));

      // Upload the selected image and get the download URL
      String? imageUrl = await _uploadImageToFirebase(_selectedImage!);

      if (imageUrl == null) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image upload failed')));
        return;
      }

      // Upload product details to Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'category': _selectedCategory,
        'product_name': _productNameController.text,
        'price': double.tryParse(_priceController.text),
        'quantity': int.tryParse(_quantityController.text),
        'old_price': double.tryParse(_oldPriceController.text),
        'discount': double.tryParse(_discountController.text),
        'description': _descriptionController.text,
        'image_url': imageUrl,
        'created_at': Timestamp.now(),
      });

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product uploaded successfully')));
      _clearFields();
      // Navigator.pop(context);
    } catch (e) {
      print("Error uploading product: $e");
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product upload failed')));
    }
  }

  // Function to upload image to Firebase Storage and return the download URL
  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      // Create a unique file name based on the timestamp
      String fileName = basename(imageFile.path);
      Reference storageRef = FirebaseStorage.instance.ref().child('product_images/$fileName');
      
      // Upload the image file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      
      // Get the download URL of the uploaded image
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Function to clear all input fields
  void _clearFields() {
    setState(() {
      _selectedImage = null;
      _selectedCategory = null;
      _productNameController.clear();
      _priceController.clear();
      _quantityController.clear();
      _oldPriceController.clear();
      _discountController.clear();
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload new Med'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8.0),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Pick Product Image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16.0),

              // Dropdown for Category Selection
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _categoryItems,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                value: _selectedCategory,
              ),

              SizedBox(height: 16.0),
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Title',
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLength: 80,
              ),
              SizedBox(height: 16.0),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        filled: true,
                        fillColor: Colors.black12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Qty',
                        filled: true,
                        fillColor: Colors.black12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _oldPriceController,
                      decoration: InputDecoration(
                        labelText: 'Old Price',
                        filled: true,
                        fillColor: Colors.black12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _discountController,
                      decoration: InputDecoration(
                        labelText: 'Discount',
                        filled: true,
                        fillColor: Colors.black12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Product Description',
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLength: 1000,
                maxLines: 3,
              ),

              SizedBox(height: 26.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _clearFields();  // Clear all fields
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.clear, color: Colors.white),
                          SizedBox(width: 22),
                          Text('Clear', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _uploadProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.upload, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Upload Product', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
