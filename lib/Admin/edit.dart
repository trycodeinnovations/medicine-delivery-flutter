import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:path/path.dart'; 

class EditProductScreen extends StatefulWidget {
  final String productsId; // Pass the product ID to edit

 EditProductScreen({required this.productsId}) : assert(productsId.isNotEmpty, "Product ID cannot be empty");

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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

   Map<String, dynamic> productData ={};

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
    _fetchCategories();
  }


  Future<void> _deleteProduct() async {
  try {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productsId)
        .delete();

    // Show a message after successful deletion
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product deleted successfully')));

    // Navigate back to the previous screen
    // Navigator.pop(context);
  } catch (e) {
    print("Error deleting product: $e");
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting product')));
  }
}

  // Function to fetch product details from Firestore
  Future<void> _fetchProductDetails() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productsId)
          .get();

      if (productSnapshot.exists) {
        productData = productSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _productNameController.text = productData['product_name'] ?? '';
          _priceController.text = productData['price']?.toString() ?? '';
          _quantityController.text = productData['quantity']?.toString() ?? '';
          _oldPriceController.text = productData['old_price']?.toString() ?? '';
          _discountController.text = productData['discount']?.toString() ?? '';
          _descriptionController.text = productData['description'] ?? '';
          _selectedCategory = productData['category'];

          // Load image from URL
          if (productData['image_url'] != null) {
            _selectedImage = null; // Do not create a File object from a URL
          }
        });
      }
    } catch (e) {
      print("Error fetching product details: $e");
    }
  }

  // Function to fetch categories from Firestore
  Future<void> _fetchCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();

      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem(
          child: Text(doc['name']),
          value: doc.id,
        );
      }).toList();

      setState(() {
        _categoryItems = items;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  // Function to upload image to Firebase Storage
  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = basename(imageFile.path);
      Reference storageRef = FirebaseStorage.instance.ref().child('product_images/$fileName');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Function to update the product in Firestore
  Future<void> _updateProduct() async {
    try {
      String? imageUrl;

      if (_selectedImage != null) {
        imageUrl = await _uploadImageToFirebase(_selectedImage!);
      }

      await FirebaseFirestore.instance.collection('products').doc(widget.productsId).update({
        'category': _selectedCategory,
        'product_name': _productNameController.text,
        'price': double.tryParse(_priceController.text),
        'quantity': int.tryParse(_quantityController.text),
        'old_price': double.tryParse(_oldPriceController.text),
        'discount': double.tryParse(_discountController.text),
        'description': _descriptionController.text,
        'image_url': imageUrl ?? '', // Update image URL if a new image is uploaded
      });

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated successfully')));
      // Navigator.pop(context); // Return to previous screen after update
    } catch (e) {
      print("Error updating product: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _categoryItems.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show loading spinner while categories are being fetched
            : SingleChildScrollView(
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
          : (_productNameController.text.isNotEmpty && _selectedCategory != null)
              ? DecorationImage(
                  image: NetworkImage(
                    // Use the product's image URL from Firestore if available
                    _selectedImage == null ? productData['image_url'] : 'https://via.placeholder.com/150',
                  ),
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

                    // Category Dropdown
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
          _deleteProduct();  // Call delete product function
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Row(
          children: [
            Icon(Icons.delete, color: Colors.white),  // Change icon to delete
            SizedBox(width: 22),
            Text('Delete', style: TextStyle(color: Colors.white)),  // Change label to Delete
          ],
        ),
      ),
    ),
    SizedBox(width: 16.0),
    Expanded(
      child: ElevatedButton(
        onPressed: _updateProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Row(
          children: [
            Icon(Icons.upload, color: Colors.white),
            SizedBox(width: 8),
            Text('Update Product', style: TextStyle(color: Colors.white)),
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

  // void _clearFields() {
  //   setState(() {
  //     _selectedImage = null;
  //     _selectedCategory = null;
  //     _productNameController.clear();
  //     _priceController.clear();
  //     _quantityController.clear();
  //     _oldPriceController.clear();
  //     _discountController.clear();
  //     _descriptionController.clear();
  //   });
  // }
}
