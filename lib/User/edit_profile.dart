import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medquick/User/textfield.dart';
import 'package:medquick/bottom_navigation.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch the user data based on logged-in user's email
  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String email = user.email!;

      try {
        // Fetch user document where email matches the logged-in user's email
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(email) // Assuming email is used as the document ID, or replace with appropriate query if needed
            .get();

        if (userDoc.exists) {
          // Populate the text fields with user data
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            firstnameController.text = userData['firstname'] ?? '';
            lastnameController.text = userData['lastname'] ?? '';
            phoneController.text = userData['phone'] ?? '';
          });
        } else {
          print("User not found");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text('Personal Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 30),
            CustomeTextfield(
              username: 'First name',
              prifix: Icon(Icons.person, color: Colors.green[400]),
              controller: firstnameController,
            ),
            SizedBox(height: 20),
            CustomeTextfield(
              username: 'Last name',
              prifix: Icon(Icons.person, color: Colors.green[400]),
              controller: lastnameController,
            ),
            SizedBox(height: 20),
            CustomeTextfield(
              username: 'Phone no.',
              prifix: Icon(Icons.phone_android_outlined, color: Colors.green[400]),
              controller: phoneController,
            ),
            SizedBox(height: 20),
            SizedBox(height: 110),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>NavigatorPage()));
                updateProfile(firstnameController.text, lastnameController.text, phoneController.text);
                
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(18),
                ),
                height: 50,
                width: 400,
                child: Center(
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Method to update the user profile in Firestore
  Future<void> updateProfile(String firstname, String lastname, String phone) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String email = user.email!;

      try {
        // Update the user document with new data
        await _firestore.collection('users').doc(email).update({
          'firstname': firstname,
          'lastname': lastname,
          'phone': phone,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Sorry, something went wrong"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
