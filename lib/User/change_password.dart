import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentpasswordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController confirmnewpasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to update password
  Future<void> _changePassword() async {
    try {
      // Get current user
      User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No user is signed in."),
        ));
        return;
      }

      // Check if the new password and confirm password match
      if (newpasswordController.text != confirmnewpasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("New password and confirm password do not match."),
        ));
        return;
      }

      // Reauthenticate the user with the current password
      String? email = user.email;
      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("User email is not available."),
        ));
        return;
      }

      print('Current password: ${currentpasswordController.text}');  // Debug print

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentpasswordController.text,
      );

      await user.reauthenticateWithCredential(credential).catchError((error) {
        print('Reauthentication error: ${error.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Reauthentication failed. Please check your current password."),
        ));
      });

      // If reauthentication is successful, update the password
      await user.updatePassword(newpasswordController.text);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password updated successfully."),
      ));

      // Clear the text fields
      currentpasswordController.clear();
      newpasswordController.clear();
      confirmnewpasswordController.clear();

    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred: ${e.code}';
      if (e.code == 'wrong-password') {
        message = 'Current password is incorrect.';
      } else if (e.code == 'weak-password') {
        message = 'The new password is too weak.';
      } else {
        message = 'An error occurred: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong. Please try again."),
      ));
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
        title: Text('Change Password', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextField(
              controller: currentpasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current password',
                prefixIcon: Icon(Icons.lock_open, color: Colors.green[300]),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: newpasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_open, color: Colors.green[300]),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmnewpasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock_open, color: Colors.green[300]),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 110),
            InkWell(
              onTap: _changePassword, // Call the password change function
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(18),
                ),
                height: 50,
                width: 400,
                child: Center(
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
