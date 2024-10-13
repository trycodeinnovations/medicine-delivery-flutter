import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medquick/Api_integration/profileAPI.dart';
import 'package:medquick/bottom_navigation.dart';

Future <void> Login(context,email,password)async{
  FirebaseAuth loginauth=FirebaseAuth.instance;
  try{
    UserCredential logincred = await loginauth.signInWithEmailAndPassword(email: email, password: password);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfull"),backgroundColor: Colors.green,));
    profileGet();
    Navigator.push(context, MaterialPageRoute(builder: (context) => (NavigatorPage()),));
  
  }
  catch(e){

  }
}