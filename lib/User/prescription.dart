import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Pre extends StatelessWidget {
  Pre({super.key});

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        // Handle the picked file, e.g., display it, upload it, etc.
        print("Image selected: ${pickedFile.path}");
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text("Upload prescription"),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          Text("Choose any option to add your prescription!"),
          SizedBox(height: 50),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      icon: Icon(Icons.photo_camera_outlined),
                    ),
                    Text("Take photo"),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      icon: Icon(Icons.photo_outlined),
                    ),
                    Text("Upload from Gallery"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 80),
          ElevatedButton(
            onPressed: () {},
            child: Text("Submit"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
              minimumSize: Size(200, 50), 
              padding: EdgeInsets.symmetric(horizontal: 16), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
