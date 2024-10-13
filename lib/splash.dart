import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medquick/bottom_navigation.dart';
import 'package:medquick/getstated.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), 
    );

    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

  
    _controller.forward();

    
    waitForNavigation();
  }

 
  void waitForNavigation() async {
    await Future.delayed(Duration(seconds: 3)); 

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // If the user is logged in, navigate to the home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigatorPage()));
    } else {
      // If no user is logged in, navigate to the login screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => GetStartedScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/Image/splashimage.jpg",
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
         
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: Container(
                  width: 200,
                  child: Image.asset(
                    "assets/Image/logo2.png",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




