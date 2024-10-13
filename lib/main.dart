import 'package:flutter/material.dart';
import 'package:medquick/Admin/addMed.dart';
import 'package:medquick/Admin/addbanner.dart';
import 'package:medquick/Admin/delivery.dart';
import 'package:medquick/Admin/home.dart';
import 'package:medquick/Admin/orderasign.dart';
import 'package:medquick/Admin/rating.dart';
import 'package:medquick/DeliveryPerson/home.dart';
import 'package:medquick/DeliveryPerson/navigator.dart';
import 'package:medquick/DeliveryPerson/orders.dart';
import 'package:medquick/DeliveryPerson/otp_screen.dart';
import 'package:medquick/DeliveryPerson/product_details.dart';
import 'package:medquick/DeliveryPerson/thanku_screen.dart';
import 'package:medquick/User/about_us.dart';

import 'package:medquick/User/addres_screen.dart';
import 'package:medquick/User/cart_screen.dart';
import 'package:medquick/User/change_password.dart';
import 'package:medquick/User/cod_confirmedscreen.dart';
import 'package:medquick/User/delete_acc.dart';
import 'package:medquick/User/edit_profile.dart';
import 'package:medquick/User/home.dart';
import 'package:medquick/User/medicine.dart';
import 'package:medquick/User/myorders.dart';
import 'package:medquick/User/orderhistory_Screen.dart';
import 'package:medquick/User/payment_screen.dart';
import 'package:medquick/User/personalcare.dart';
import 'package:medquick/User/productScreen.dart';
import 'package:medquick/User/profile.dart';
import 'package:medquick/User/rating.dart';
import 'package:medquick/User/saved_address.dart';
import 'package:medquick/User/supportAid.dart';
import 'package:medquick/bottom_navigation.dart';
import 'package:medquick/getstated.dart';

import 'package:medquick/login.dart';

import 'package:medquick/pharmascist/home.dart';

import 'package:medquick/splash.dart';
  import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{

WidgetsFlutterBinding.ensureInitialized();
// ...

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  
      // NavigatorPage(),
           PharmacistApp(),
          //  ManageDeliveryBoysScreen()
      // (title: 'Flutter Demo Home Page'),
    );
  }
}

