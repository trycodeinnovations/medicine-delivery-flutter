
import 'package:flutter/material.dart';
import 'package:medquick/Api_integration/registerAPI.dart';
// import 'package:self_billing/screen/bar.dart';
// import 'package:self_billing/screen/login.dart';
// import 'package:self_billing/screen/staff_home.dart';
// import 'package:self_billing/services/loginApi.dart';
// import 'package:self_billing/services/user/registrationApi.dart';

class Reg1 extends StatefulWidget {
  static const String path = "lib/src/pages/login/login7.dart";

  const Reg1({super.key});
  @override
  _Reg1State createState() => _Reg1State();
}

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmpasswordController = TextEditingController();

   final _formkey = GlobalKey<FormState>();


class _Reg1State extends State<Reg1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipper2(),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color.fromARGB(32, 247, 221, 225), Color.fromARGB(33, 252, 198, 198)])),
                    child: Column(),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper3(),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                    child: Column(),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper1(),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.white])),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children:  <Widget>[
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_ios_new)),
                        Container(
                        width: double.infinity,
                        child: Image.asset("assets/Image/banner2.png"),
                       ),
                        // Icon(
                        //   Icons.shopify,
                        //   color: Colors.white,
                        //   size: 99,
                        // ),
                        // SizedBox(
                        //   height: 6,
                        // ),
                        // Text(
                        //   "EASY BUY",
                        //   style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w700,
                        //       fontSize: 30),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  validator: (value) {
                    if(value == null || value ==""){
                      return "field cant be empty";
                    }
                    else{
                      return null;
                    }
                  },
                  controller: firstnameController,
                  onChanged: (String value) {},
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                      hintText: "First name",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person_pin,
                          color: Colors.teal,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  validator: (value) {
                    if(value == null || value ==""){
                      return "field cant be empty";
                    }
                    else{
                      return null;
                    }
                  },
                  controller: lastnameController,
                  onChanged: (String value) {},
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                      hintText: "Last name",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person_pin,
                          color: Colors.teal,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  validator: (value) {
                    if (value == "") {
                        return "Field can't be empty";
                      } else if (isValidEmail(value!) == false) {
                        return "enter a valid email";
                      }
                      return null;
                  },
                  controller: emailController,
                  onChanged: (String value) {},
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.email,
                          color: Colors.teal,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  validator: (value) {
                    if(value == null){
                      return "field cant be empty";
                    }
                    else if(value.length <10 || value.length>10){
                      return "phone number should contain 10 numbers";
                    }
                  },
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: phoneController,
                  onChanged: (String value) {},
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                      hintText: "Phone no.",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.phone_rounded,
                          color: Colors.teal,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  validator: (value) {
                    if (value == ""|| value ==null) {
                        return "Field can't be empty";
                      } else if (value.length<3) {
                        return "password should contain min 3 character";
                      }
                      return null;
                  },
                  controller: passwordController,
                  onChanged: (String value) {},
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: Colors.teal,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  validator: (value) {
                    if (value == ""|| value ==null) {
                        return "Field can't be empty";
                      } else if (value.length<3) {
                        return "password should contain min 3 character";
                      }
                      // else if(passwordController.value != value){
                      //   return "confirm password and password should be same";
                      // }
                      return null;
                  },
                  controller: confirmpasswordController,
                  onChanged: (String value) {},
                  cursorColor: Colors.teal,
                  decoration: const InputDecoration(
                      hintText: "Confirm password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: Colors.teal,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.teal),
                  child: TextButton(
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async{
                      // if (_formkey.currentState!.validate()) {
                      //   regCheck();
                      // }
                      Map<String,dynamic> data={
                        "firstname":firstnameController.text,
                        "lastname":lastnameController.text,
                        "phone":phoneController.text,
                        "email":emailController.text,
                        
                      };
                      await Register(emailController.text,passwordController.text,data,context);
                      
                      print('hello');
                     
                      //await loginApi(emailController.text, passwordController.text);
                    },
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
         
          ],
        ),
      ),
    );
  }

  //login func
  // regCheck() async{
  //   final res =  await regApi(firstnameController.text, passwordController.text, emailController.text, lastnameController.text, phoneController.text);
  //   if (res == "success") {
  //        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //               content: Text("successfully registered"),
  //               backgroundColor: Colors.green,
  //               behavior: SnackBarBehavior.floating,
  //               margin: EdgeInsets.all(10),
  //               duration: Duration(seconds:3)));

  //                      Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => LoginSevenPage()));
  //   }
  //   else{
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //               content: Text("Something went wrong"),
  //               backgroundColor: Colors.red,
  //               behavior: SnackBarBehavior.floating,
  //               margin: EdgeInsets.all(10),
  //               duration: Duration(seconds:8)));
  //   }     
  // }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}