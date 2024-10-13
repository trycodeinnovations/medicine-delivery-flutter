import 'dart:async'; // Import this for the Timer
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:flutter/material.dart';
import 'package:medquick/Api_integration/profileAPI.dart';
import 'package:medquick/User/cart_screen.dart';
import 'package:medquick/User/medicine.dart';
import 'package:medquick/User/personalcare.dart';
import 'package:medquick/User/prescription.dart';
import 'package:medquick/User/search_result.dart';
import 'package:medquick/User/supportAid.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imageUrls = [
    "assets/Image/WhatsApp Image 2024-08-08 at 00.20.13_5e262803.jpg",
    "assets/Image/WhatsApp Image 2024-08-08 at 00.20.13_72df19ec.jpg",
    "assets/Image/WhatsApp Image 2024-08-08 at 00.20.14_1883336f.jpg",
  ];
 TextEditingController searchController = TextEditingController();
  final PageController _pageController = PageController();
  Timer? _timer;

  // Firestore reference for the products collection
  CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    super.initState();

    // Timer for automatic swiping
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= imageUrls.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing
    _pageController.dispose();
    super.dispose();
  }

  // Method to fetch products with discounts greater than 10%
  Stream<QuerySnapshot> getDiscountedProducts() {
    return productsRef.where('discount', isGreaterThan: 1).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Image.asset("assets/Image/logo2.png"),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome", style: TextStyle(color: Colors.black, fontSize: 17)),
            Text(notificationsData['firstname'] ?? 'no',
                style: TextStyle(color: Colors.grey, fontSize: 15)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(),
                  ));
            },
            icon: Icon(Icons.shopping_cart_outlined),
          ),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 212, 252, 227),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(searchQuery: query),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryItem(
                    imageUrl: "assets/Image/background-replacer-result.png",
                    label: 'Medicines',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopSellingMedicinesScreen(),
                        ),
                      );
                    },
                  ),
                  CategoryItem(
                    imageUrl: "assets/Image/personal-care.png",
                    label: 'Personalcare',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalcareScreen(),
                        ),
                      );
                    },
                  ),
                  CategoryItem(
                    imageUrl: "assets/Image/background-replacer-result (2).png",
                    label: 'SupportAid',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupportAidScreen(),
                        ),
                      );
                    },
                  ),
                  CategoryItem(
                    imageUrl: "assets/Image/background-replacer-result (1).png",
                    label: 'Prescription',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Pre(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Promotional Banner
              Container(
                width: double.infinity,
                height: 160,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            imageUrls[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: -20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: imageUrls.length,
                          effect: WormEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: Colors.blue,
                            dotColor: const Color.fromARGB(255, 133, 63, 63),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // Increase space after the banner and indicator
              // Deals Section
              SectionTitle(title: "Top Deals | Last Chance to buy"),
              SizedBox(height: 10),
              // StreamBuilder to display products with more than 10% discount
              StreamBuilder<QuerySnapshot>(
                stream: getDiscountedProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error loading products.");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final products = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              product['image_url'], // Image URL from Firestore
                              height: 80,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            Text(
                              product['product_name'],
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${product['discount']}% Off",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  CategoryItem({
    required this.imageUrl,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.contain,
                width: 70,
                height: 70,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("View All", style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}
