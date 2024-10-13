
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medquick/Api_integration/loginAPI.dart';
import 'package:medquick/bottom_navigation.dart';
import 'package:medquick/forgotpassword.dart';
import 'package:medquick/registrartion.dart';
// import 'package:self_billing/constants/constantVariables.dart';
// import 'package:self_billing/screen/bar.dart';
// import 'package:self_billing/screen/forgotpasswordScreen.dart';
// import 'package:self_billing/screen/registration.dart';
// import 'package:self_billing/screen/staff_home.dart';
// import 'package:self_billing/services/loginApi.dart';
// import 'package:self_billing/services/user/ViewCategoryApi.dart';
// import 'package:self_billing/services/user/ViewProductApi.dart';
// import 'package:self_billing/services/user/viewProfileapi.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginSevenPage extends StatefulWidget {
  static const String path = "lib/src/pages/login/login7.dart";

  const LoginSevenPage({super.key});
  @override
  _LoginSevenPageState createState() => _LoginSevenPageState();
}

   bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  ValueNotifier<bool> isClicked = ValueNotifier(false);
  bool isObsecure = true;

class _LoginSevenPageState extends State<LoginSevenPage> {
  final _formkey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formkey2,
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
                            colors: [Color.fromARGB(255, 42, 146, 135), Color.fromARGB(255, 170, 255, 235)])),
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
                            colors: [Color.fromARGB(255, 31, 96, 89), Color.fromARGB(255, 174, 255, 247)])),
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
                            colors: [Colors.white, Colors.white])
                            ),
                    child:  Column(
                      children:  <Widget>[
                        SizedBox(
                          height: 1,
                        ),
                        // Icon(
                        //   Icons.shopify,
                        //   color: Colors.white,
                        //   size: 99,
                        // ),
                       Container(
                        width: double.infinity,
                        child: Image.asset("assets/Image/banner2.png"),
                       ),
                        
                        SizedBox(
                          height: 6,
                        ),
                        // Text(
                        //   "MedQuick",
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  
                  obscureText: isObsecure ,
                  validator: (value) {
                    if (value == "") {
                        return "Field can't be empty";
                      } else if (value!.length<3) {
                        return "password must have min 3 characters";
                      }
                      return null;
                  },
                  controller: passwordController,
                  onChanged: (String value) {},
                  cursorColor: Colors.teal,
                  decoration:  InputDecoration(
                      hintText: "Password",
                      suffix: IconButton(onPressed: (){setState(() {
                        isObsecure? isObsecure=false: isObsecure=true;
                      });}, icon: Icon(isObsecure? Icons.visibility:Icons.visibility_off)),
                     
                      //suffix: IconButton(onPressed: (){}, icon: Icon(Icons.visibility)),
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
        
                    child: 
                    
                    ValueListenableBuilder(valueListenable: isClicked, 
                    builder: (context, value, child) {
        
                      if(isClicked.value == true){ return Center(child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,),);} 
                      else{
                        return
                         Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 18),
                    );
                      }
                     
                    },
                    ),
                    onPressed: () async{
                      Login(context, emailController.text, passwordController.text);
                      
                    //  if (_formkey2.currentState!.validate()) {
                    //     isClicked.value = true;
                    //   print('hello');
                    //   // await loginCheck();
                    //  }
                      //await loginApi(emailController.text, passwordController.text);
                    },
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotScreen(),));
                },
                child: Text(
                  "FORGOT PASSWORD ?",
                  style: TextStyle(
                      color: Colors.teal, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an Account ? ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
                TextButton(onPressed: (){
                   Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Reg1()),
              );
                }, child: Text("Sign Up ",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        decoration: TextDecoration.underline)),)
              ],
            )
          ],
        ),
      ),
    );
  }

  //login func
  // loginCheck() async{
  //   print("here");
  //   final res = await loginApi(emailController.text, passwordController.text);
  //   //print(res!.type);
  //   if (res != null){
  //     emailController.clear();
  //     passwordController.clear();
  //     print("get pro called");
  //     getProducts();
  //     getCategory();
  //     final shared = await SharedPreferences.getInstance();
  //     shared.setBool("isLogedin", true);
  //     shared.setString("lid", res.loginid.toString());
  //     shared.setString("type", res.type);
  //     isClicked.value = false;
  //     lid = res.loginid.toString();
  //     getProfile();
      
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //               content: Text("successfully logined"),
  //               backgroundColor: Colors.green,
  //               behavior: SnackBarBehavior.floating,
  //               margin: EdgeInsets.all(10),
  //               duration: Duration(seconds:3)));
  //     if (res.type=="user") { 
  //       Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => MyHomePage1()));   
  //     }
  //     if (res.type=="staff") {
  //       isClicked.value = false;
  //       Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => staffhome()));
        
  //     } 
  //   }
  //   else{
  //     isClicked.value = false;
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //               content: Text("Invalid credentials"),
  //               backgroundColor: Colors.red,
  //               behavior: SnackBarBehavior.floating,
  //               margin: EdgeInsets.all(10),
  //               duration: Duration(seconds:8)));
  //   }
  //   isClicked.value = false;
  // }

   //view products
  // getProducts() async{
  //   final res = await getviewproduct();
  //   if (res != null) {
  //     products = res;
  //     productbycategory.value = products;
  //   }
  // }

      //get profile
  // getProfile() async {
  //   final res = await profileApi();
  //   if (res != null) {
  //     profile.value = res;
  //     print("Pro : $profile");
  //   }
  //   else{
  //     print("else error");
  //   }
  // }

  //getCategory
  // getCategory() async{
  //   print("Hi hiiiii");
  //   final res = await getCategoryapi();
  //   if (res != null) {
  //     print("he he he");
  //     categories = res;
  //     print("cat $categories");
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