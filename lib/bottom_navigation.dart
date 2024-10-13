import 'package:flutter/material.dart';
import 'package:medquick/User/home.dart';
import 'package:medquick/User/profile.dart';

class NavigatorPage extends StatelessWidget {
  NavigatorPage({super.key});

  ValueNotifier<int> current = ValueNotifier(0);
  final List<Widget> screens = [HomePage(), HomePage(), ProfileScreen()];

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
              color: Color.fromARGB(255, 213, 255, 229),
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
                  selectedItemColor: Colors.teal,
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox.shrink(), 
                      label: "",
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
                
              },
              child: Image.asset(
                "assets/Image/logo2.png",
                // scale: 10,
              ),
              backgroundColor: Color.fromARGB(255, 190, 245, 211),
              elevation: 7,
            ),
          ),
        ],
      ),
    );
  }
}
