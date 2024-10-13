import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/Image/banner2.png', 
                  height: 220,
                ),
              ),
              const Center(
                child: Text(
                  'MedQuick',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Your Health, Our Priority',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Who We Are',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'MedQuick is an innovative healthcare app focused on providing quick and efficient access to medical resources and services. Whether it’s booking appointments, receiving medical advice, or managing prescriptions, MedQuick ensures that healthcare is just a tap away.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Our mission is to bridge the gap between patients and healthcare providers by offering seamless digital solutions. We aim to make healthcare more accessible, transparent, and personalized for everyone.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const ListTile(
                leading: Icon(Icons.local_hospital, color: Colors.teal),
                title: Text('Quick Appointments'),
                subtitle: Text('Book appointments with the best doctors in just a few clicks.'),
              ),
              const ListTile(
                leading: Icon(Icons.medical_services, color: Colors.teal),
                title: Text('24/7 Medical Support'),
                subtitle: Text('Access professional medical advice anytime, anywhere.'),
              ),
              const ListTile(
                leading: Icon(Icons.health_and_safety, color: Colors.teal),
                title: Text('Prescription Management'),
                subtitle: Text('Easily manage your prescriptions and get timely reminders.'),
              ),
              const ListTile(
                leading: Icon(Icons.security, color: Colors.teal),
                title: Text('Secure Data'),
                subtitle: Text('We prioritize the safety and privacy of your personal health data.'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Email: support@medquick.com\nPhone: +1 123 456 7890\nWebsite: www.medquick.com',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


