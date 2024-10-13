import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Review extends StatelessWidget {
  TextEditingController reviewController = TextEditingController();
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Share your feedback",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              child: Image.asset(
                'assets/Image/feedback.jpg',
                width: 900,
                height: 300,
              ),
            ),
            SizedBox(height: 5),
            const Text(
              "Your feedback helps us improve",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 5),
            RatingBar.builder(
              itemSize: 40,
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (double value) {
                rating = value;
                print(value);
              },
            ),
            const SizedBox(height: 15),
            const Text(
              "Leave your comments",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: () async {
                if (reviewController.text != "") {
                  final res = await addReview();
                  if (res == true) {
                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                      content: Text("Thanks for your feedback"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(10),
                      duration: Duration(seconds: 3),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                      content: Text("Oops! Something went wrong"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(10),
                      duration: Duration(seconds: 8),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Sorry, you haven't entered any feedback"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(10),
                    duration: Duration(seconds: 8),
                  ));
                }
              },
              child: Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  border: Border.all(style: BorderStyle.none),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Raise your feedback",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "No, Thank you",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add review to Firestore
  Future<bool> addReview() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email ?? 'Anonymous';

        // Save the review, rating, and user email to Firestore
        await FirebaseFirestore.instance.collection('rating').add({
          'email': email,
          'rating': rating,
          'review': reviewController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        return true;
      }
    } catch (e) {
      print("Error adding review: $e");
    }
    return false;
  }
}
