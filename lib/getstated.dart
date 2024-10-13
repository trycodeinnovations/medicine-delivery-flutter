import 'package:flutter/material.dart';
import 'package:medquick/login.dart';

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Image/getstarted.jpg"), 
                fit: BoxFit.cover, 
              ),
            ),
          ),
         
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Image.asset(
                "assets/Image/banner2.png", 
                width: 419, 
                height: 250,
              ),
            ),
          ),
        
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0), 
              child: ElevatedButton(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginSevenPage()),
    );
  },
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30), // Rounded button
    ),
    backgroundColor: const Color.fromARGB(29, 0, 0, 0), // Transparent background
    shadowColor: Colors.transparent, // Remove shadow
    elevation: 0, // Remove elevation
  ),
  child: Text(
    'Get Started',
    style: TextStyle(
      fontSize: 20,
      color: Colors.teal.shade400,
    ),
  ),
)

            ),
          ),
        ],
      ),
    );
  }
}

