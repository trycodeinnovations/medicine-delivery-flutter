import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliveryBoy {
  String id; // Firestore document ID
  String name;
  String phone;
  String email;
  String password; // New password field

  DeliveryBoy({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password, // Initialize password
  });

  // Create a method to convert a Firestore document into a DeliveryBoy object
  factory DeliveryBoy.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeliveryBoy(
      id: doc.id,
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      password: data['password'], // Fetch password from Firestore
    );
  }

  // Convert DeliveryBoy object to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password, // Include password for Firestore
    };
  }
}

class ManageDeliveryBoysScreen extends StatefulWidget {
  @override
  _ManageDeliveryBoysScreenState createState() => _ManageDeliveryBoysScreenState();
}

class _ManageDeliveryBoysScreenState extends State<ManageDeliveryBoysScreen> {
  CollectionReference deliveryBoysCollection = FirebaseFirestore.instance.collection('deliveryBoys');

  // Fetch delivery boys from Firestore
  Stream<List<DeliveryBoy>> getDeliveryBoys() {
    return deliveryBoysCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DeliveryBoy.fromDocument(doc)).toList();
    });
  }

  // Add or update delivery boy
  void addOrUpdateDeliveryBoy({DeliveryBoy? existingBoy, String? name, String? phone, String? email, String? password}) {
    if (existingBoy != null) {
      // Update existing delivery boy in Firestore
      deliveryBoysCollection.doc(existingBoy.id).update({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password, // Update password in Firestore
      });
    } else {
      // Add new delivery boy to Firestore
      deliveryBoysCollection.add({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password, // Add password to Firestore
      });
    }
  }

  // Delete delivery boy from Firestore
  void deleteDeliveryBoy(DeliveryBoy deliveryBoy) {
    deliveryBoysCollection.doc(deliveryBoy.id).delete();
  }

  // Dialog to add or update delivery boy
  Future<void> showAddOrUpdateDialog({DeliveryBoy? deliveryBoy}) async {
    final TextEditingController nameController = TextEditingController(text: deliveryBoy?.name ?? '');
    final TextEditingController phoneController = TextEditingController(text: deliveryBoy?.phone ?? '');
    final TextEditingController emailController = TextEditingController(text: deliveryBoy?.email ?? '');
    final TextEditingController passwordController = TextEditingController(text: deliveryBoy?.password ?? ''); // Add password controller

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(deliveryBoy == null ? 'Add Delivery Boy' : 'Update Delivery Boy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'), // Add password field
                obscureText: true, // Mask password
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String newName = nameController.text.trim();
                final String newPhone = phoneController.text.trim();
                final String newEmail = emailController.text.trim();
                final String newPassword = passwordController.text.trim(); // Get password value

                if (newName.isNotEmpty && newPhone.isNotEmpty && newEmail.isNotEmpty && newPassword.isNotEmpty) {
                  addOrUpdateDeliveryBoy(
                    existingBoy: deliveryBoy,
                    name: newName,
                    phone: newPhone,
                    email: newEmail,
                    password: newPassword, // Pass password for add or update
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: Text(deliveryBoy == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Delivery Boys'),
      ),
      body: StreamBuilder<List<DeliveryBoy>>(
        stream: getDeliveryBoys(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No delivery boys found. Add one!'));
          }

          final deliveryBoyz = snapshot.data!;

          return ListView.builder(
            itemCount: deliveryBoyz.length,
            itemBuilder: (context, index) {
              final deliveryBoy = deliveryBoyz[index];

              return ListTile(
                title: Text(deliveryBoy.name),
                subtitle: Text('Phone: ${deliveryBoy.phone}\nEmail: ${deliveryBoy.email}\n'), // Show password
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showAddOrUpdateDialog(deliveryBoy: deliveryBoy),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteDeliveryBoy(deliveryBoy),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton( backgroundColor: Colors.teal,
        onPressed: () => showAddOrUpdateDialog(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
