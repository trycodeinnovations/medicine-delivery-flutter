import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth =FirebaseAuth.instance;
final FirebaseFirestore firestore=FirebaseFirestore.instance;

Future<void>Register(email,password,data,context)async{
  try {
    UserCredential credential= await auth.createUserWithEmailAndPassword(email: email, password: password);
    await firestore.collection("users").doc(email).set(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Registration successful")));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registration Failed:${e.toString()}"))
    );
    print(e);
  }
}