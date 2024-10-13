import 'package:flutter/material.dart';
import 'package:medquick/Admin/addMed.dart';
import 'package:medquick/Admin/addbanner.dart';
import 'package:medquick/Admin/addcat.dart';
import 'package:medquick/Admin/delivery.dart';
import 'package:medquick/Admin/inspect.dart';
import 'package:medquick/Admin/orderasign.dart';
import 'package:medquick/Admin/rating.dart';
import 'package:medquick/Admin/viewall.dart';

class Adhome extends StatelessWidget {
  const Adhome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerItem(context,Icons.person, 'Add delivery boy',ManageDeliveryBoysScreen() ),
            _buildDrawerItem(context,Icons.star, 'View Rating', AdminUserRatingApp()),
            _buildDrawerItem(context,Icons.branding_watermark_outlined, 'Add Banner', ImageUploadScreen()),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Manage Options',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDashboardCard(
                  context,
                  "Add Medicine",
                  Icons.medication_liquid_sharp,
                  Colors.green,
                  UploadProductScreen(),
                ),
                _buildDashboardCard(
                  context,
                  "View orders",
                  Icons.grid_view_rounded,
                  Colors.blue,
                  AdminOrderScreen(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDashboardCard(
                  context,
                  "Inspect",
                  Icons.zoom_in_rounded,
                  Colors.orange,
                  Inspect(),
                ),
                _buildDashboardCard(
                  context,
                  "Add Category",
                  Icons.category_rounded,
                  Colors.purple,
                  CategoryManagementPage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Drawer item builder
  ListTile _buildDrawerItem(BuildContext context,IconData icon, String title, Widget onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => onTap));
      },
    );
  }

  // Dashboard card builder
  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color iconColor, Widget navigateTo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => navigateTo));
      },
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Container(
          height: 140,
          width: 140,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: iconColor),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
