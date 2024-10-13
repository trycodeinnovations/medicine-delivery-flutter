import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:medquick/Api_integration/addcatAPI.dart'; // Import your API integration file
import 'package:cloud_firestore/cloud_firestore.dart';    // Import Firestore

class Category {
  String name;
  String description;
  String? imageUrl; // Changed from File? to String? to store the image URL from Firestore

  Category({required this.name, required this.description, this.imageUrl});
}

class CategoryManagementPage extends StatefulWidget {
  @override
  _CategoryManagementPageState createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final TextEditingController namecontroller = TextEditingController();
  final picker = ImagePicker();

  // Add or edit category
  void _addEditCategory({Category? category}) {
    final _formKey = GlobalKey<FormState>();
    String name = category?.name ?? '';
    String? imageUrl = category?.imageUrl;
    File? img;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: namecontroller,
                  initialValue: name.isNotEmpty ? name : null,
                  decoration: InputDecoration(labelText: 'Category Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                  onSaved: (value) => name = value!,
                ),
                SizedBox(height: 10,),
                Row(children: [   
                   imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 50),
                      ),

                        ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          img = File(pickedFile.path); // Update image variable
                        });
                      }
                    },
                    child: Text('Pick Image'),
                  ),],),
                SizedBox(height: 16),
               
                  
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Upload image and category details to Firebase
                // if (imageUrl != null) {
                  await addCategoryWithImage(img!, namecontroller.text); // Upload category name and image
                // }

                Navigator.of(context).pop();
              }
            },
            child: Text(category == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete category
  void _deleteCategory(String docId) async {
    await FirebaseFirestore.instance.collection('categories').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Categories'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No categories found.'));
          }

          // Get the list of categories from Firestore
          final categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              String categoryName = category['name'];
              String imageUrl = category['imageUrl'];
              String docId = category.id; // Firestore document ID

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.category, size: 50),
                  title: Text(categoryName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _addEditCategory(category: Category(name: categoryName, description: '', imageUrl: imageUrl)),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteCategory(docId),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEditCategory(),
        child: Icon(Icons.add),
      ),
    );
  }
}
