import 'package:flutter/material.dart';
import 'package:medquick/DeliveryPerson/home.dart';
import 'package:medquick/DeliveryPerson/orders.dart';
import 'package:medquick/DeliveryPerson/profileD.dart';
import 'package:medquick/User/home.dart';
import 'package:medquick/User/profile.dart';

class NavigatorPage2 extends StatelessWidget {
  NavigatorPage2({super.key});

  ValueNotifier<int> current = ValueNotifier(0);
  final List<Widget> screens = [HomeScreen(),ProfileScreenD()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: current,
        builder: (context, value, child) {
          return screens[value];
        },
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ValueListenableBuilder<int>(
              valueListenable: current,
              builder: (context, value, child) {
                return BottomNavigationBar(
                  onTap: (index) {
                    current.value = index;
                  },
                  selectedItemColor: Colors.deepPurpleAccent,
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: "Home",
                    ),
                    
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline_sharp),
                      label: "Profile",
                    ),
                  ],
                  currentIndex: value,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                );
              },
            ),
          ),
          Positioned(
            bottom: 35, 
            child: FloatingActionButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>Orders() ,));
              },
              child: Icon(Icons.shopping_bag_outlined,),
              backgroundColor: Colors.white,
              elevation: 7,
            ),
          ),
        ],
      ),
    );
  }
}
