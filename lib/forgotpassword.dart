// import 'package:flutter/material.dart';
// import 'package:self_billing/constants/sizes.dart';
// import 'package:self_billing/services/user/forgotOtpsendApi.dart';

// class ForgotScreen extends StatelessWidget {
//   ForgotScreen({super.key});

//   final emailController = TextEditingController();
//   final otpController = TextEditingController();
//   final newpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Text("Enter your email"),
//           h20,
//           TextFormField(
//             controller: emailController,
//           ),

//           ElevatedButton(onPressed: (){
//             forgotOtpapi(emailController.text,context);
//           }, child: Text("send Otp"))

//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
// import 'package:self_billing/screen/login.dart';
// import 'package:self_billing/services/user/forgotOtpsendApi.dart';

class ForgotScreen extends StatelessWidget {
  ForgotScreen({Key? key}) : super(key: key);

  TextEditingController emailcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _formkey = GlobalKey<FormState>();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(" "),
      //   backgroundColor: Color.fromARGB(255, 255, 255, 255),
      // ),
      body: Form(
        key: _formkey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipper2(),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(32, 247, 221, 225),
                      Color.fromARGB(33, 252, 198, 198)
                    ])),
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
                      children: <Widget>[
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_ios_new)),
                        SizedBox(
                          height: 20,
                        ),
                        
                        // Icon(
                        //   Icons.shopify,
                        //   color: Colors.white,
                        //   size: 99,
                        // ),
                        Container(
                          width: double.infinity,
                          child: Image.asset(
                              "assets/Image/WhatsApp Image 2024-08-07 at 16.07.20_9bb628b3.jpg"),
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
            Text(
              "Forgot Your Password?",
              style: TextStyle(
                fontSize: 24,
                // fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Enter your email address below to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid email';
                    }
                    // You can add more email validation logic here if needed
                    return null;
                  },
                  controller: emailcont,
                  onChanged: (String value) {},
                  cursorColor: Colors.deepPurpleAccent,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.email,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 40,
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  //                     if(_formkey.currentState!.validate()){
                  // await   forgotOtpapi(emailcont.text,context);
                  //                     }
                },
                child: Text("Send OTP"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Color.fromARGB(255, 252, 253, 253),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
