import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart'; 
import 'package:url_launcher/url_launcher.dart'; 



class PharmacistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: PrescriptionListScreen(),
    );
  }
}

class PrescriptionListScreen extends StatefulWidget {
  @override
  _PrescriptionListScreenState createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  List<Map<String, dynamic>> prescriptions = [
    {
      'name': 'Varun Raj',
      'prescription': 'Prescription 1',
      'phone': '+91 9744513904',
      'image': 'https://www.businessleague.in/wp-content/uploads/2022/09/kerla.jpg',
      'status': 'Pending',
      'products': ['Aspirin 100mg', 'Paracetamol 500mg', 'Amoxicillin 250mg']
    },
    {
      'name': 'Sruthi S',
      'prescription': 'Prescription 2',
      'phone': '+0987654321',
      'image': 'https://cdn.slidesharecdn.com/ss_thumbnails/bhargavdrprescription20100218-100310052805-phpapp02-thumbnail-4.jpg?cb=1268198899',
      'status': 'Pending',
      'products': ['Ibuprofen 400mg', 'Ciprofloxacin 500mg']
    },
  ];

  void _callUser(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _updatePrescriptionStatus(int index, String status) {
    setState(() {
      prescriptions[index]['status'] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacist Dashboard'),
        backgroundColor: Colors.green.shade400,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.green.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = prescriptions[index];
            return PrescriptionCard(
              name: prescription['name']!,
              prescriptionDetail: prescription['prescription']!,
              phone: prescription['phone']!,
              imageUrl: prescription['image']!,
              status: prescription['status']!,
              products: prescription['products'] as List<String>,
              onCallPressed: () => _callUser(prescription['phone']!),
              onViewPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionDetailScreen(
                      index: index,
                      name: prescription['name']!,
                      prescriptionDetail: prescription['prescription']!,
                      imageUrl: prescription['image']!,
                      products: prescription['products'] as List<String>,
                      status: prescription['status']!,
                      onApprove: () => _updatePrescriptionStatus(index, 'Approved'),
                    ),
                  ),
                );
              },
              onImagePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageScreen(
                      imageUrl: prescription['image']!,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  final String name;
  final String prescriptionDetail;
  final String phone;
  final String imageUrl;
  final String status;
  final List<String> products;
  final VoidCallback onCallPressed;
  final VoidCallback onViewPressed;
  final VoidCallback onImagePressed;

  PrescriptionCard({
    required this.name,
    required this.prescriptionDetail,
    required this.phone,
    required this.imageUrl,
    required this.status,
    required this.products,
    required this.onCallPressed,
    required this.onViewPressed,
    required this.onImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: onImagePressed, // Tapping the image shows the full-screen view
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    prescriptionDetail,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      color: status == 'Pending' ? Colors.orange : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed: onCallPressed,
                ),
                IconButton(
                  icon: Icon(Icons.remove_red_eye, color: Colors.blueAccent),
                  onPressed: onViewPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionDetailScreen extends StatelessWidget {
  final int index;
  final String name;
  final String prescriptionDetail;
  final String imageUrl;
  final List<String> products;
  final String status;
  final VoidCallback onApprove;

  PrescriptionDetailScreen({
    required this.index,
    required this.name,
    required this.prescriptionDetail,
    required this.imageUrl,
    required this.products,
    required this.status,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name\'s Prescription'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageScreen(
                      imageUrl: imageUrl,
                    ),
                  ),
                );
              },
              child: Center(
                child: Image.network(imageUrl, height: 200),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Prescription Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              prescriptionDetail,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Products:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...products.map((product) => Text(
              product,
              style: TextStyle(fontSize: 16),
            )),
            SizedBox(height: 20),
            if (status == 'Pending') ...[
              Center(
                child: ElevatedButton(
                  onPressed: onApprove,
                  child: Text('Approve Prescription',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  FullScreenImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Image'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.black,
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
