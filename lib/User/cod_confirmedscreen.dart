import 'package:flutter/material.dart';
import 'package:medquick/User/home.dart';
import 'package:medquick/bottom_navigation.dart';

class orderconfirmed extends StatelessWidget {
  const orderconfirmed({super.key, this.items, this.newAddress});
  final items;
  final newAddress;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        title: Text("Order placed"),
      ),
      
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            height: 190,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12),border: Border.all(color: Colors.black12)),
                child: const Column(
                  children: [
                    SizedBox(height: 10,),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Color.fromARGB(255, 72, 161, 36),
                      child: Icon(Icons.check,color: Colors.white,),
                    ),
                    SizedBox(height: 10,),
                    Text("Order Confirmed",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                    Text("The medicines will reach you soon",style: TextStyle(color: Colors.grey),),
                    SizedBox(height: 20,),
                    Text("item confirmed",style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          const ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.home_outlined,size: 32,color: Colors.black54,),
            title: Row(
              children: [
                Text("Deliver to",style: TextStyle(color: Colors.grey),),SizedBox(width: 4,),
                Text("Home, 673008",style: TextStyle(fontWeight: FontWeight.w600),)
              ],
            ),
            subtitle: Column(
              children: [
                Text("Krishnarchana, Calicut 673008, kerala Kozhikode, kerala",style: TextStyle(color: Colors.grey)),
                // Text("Kerala",style: TextStyle(color: Colors.grey))
              ],
            ),
          ),
          SizedBox(height: 50,),
          Center(
                child: 
              ElevatedButton(
                    onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>NavigatorPage() ,));
                        },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Button background color
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min, // To make the button wrap its content
    children: [
      Text(
        "Continue Shopping",
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(width: 8), // Add some space between the text and the icon
      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
    ],
  ),
)

                
              ),
        ],
      ),
    );
  }
}