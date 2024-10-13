import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medquick/User/about_us.dart';
import 'package:medquick/User/change_password.dart';
import 'package:medquick/User/delete_acc.dart';
import 'package:medquick/User/edit_profile.dart';
import 'package:medquick/User/orderhistory_Screen.dart';
import 'package:medquick/User/rating.dart';
import 'package:medquick/User/saved_address.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variables to store user details
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch user data from Firestore based on the logged-in user's email
  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        String email = user.email!;

        // Fetch user document from Firestore where the email matches the logged-in user's email
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(email).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            firstName = userData['firstname'] ?? 'No name';
            lastName = userData['lastname'] ?? '';
            this.email = userData['email'] ?? 'No email';
            phone = userData['phone'] ?? 'No phone';
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color.fromRGBO(243, 243, 243, 1), Colors.greenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.greenAccent),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$firstName $lastName',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(email),
                            Text(phone),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PersonalDetails()), // Navigate to the edit profile page
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            buildListTile(
              Icons.shopping_bag,
              'Orders',
              context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrdersPage()),
                );
              },
            ),
            buildListTile(
              Icons.location_on,
              'Addresses',
              context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedAddressesPage()),
                );
              },
            ),
            buildListTile(
              Icons.lock_rounded,
              'Change Password',
              context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              },
            ),
            buildListTile(
              Icons.support_agent_rounded,
              'About Us',
              context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AboutUsScreen()),
                );
               
              },
            ),
            buildListTile(
              Icons.star,
              'Ratings & Reviews',
              context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Review()),
                );
              },
            ),
            buildListTile(
              Icons.settings,
              'Account Settings',
              context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSettingsScreen()),
                );
              },
            ),
            buildListTile(
              Icons.logout,
              'Log Out',
              context,
              onTap: () {
                // Log out logic here
                _auth.signOut();
                Navigator.pop(context); // Pop the current screen
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, BuildContext context,
      {Widget? trailing, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
