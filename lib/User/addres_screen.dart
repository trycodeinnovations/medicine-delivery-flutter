import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medquick/User/Model/addressmodel.dart';
import 'package:medquick/User/payment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquick/login.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key, required this.items, required this.totalAmt});
  final items;
  final totalAmt;

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  // Controllers for text fields
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>(); // Global key for form
  String _addressType = 'Home';

  @override
  void dispose() {
    _pinCodeController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _emailController.dispose();
    _phonenoController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pin Code is required';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  String? _validateLandmark(String? value) {
    if (value == null || value.isEmpty) {
      return 'Landmark is required';
    }
    return null;
  }

   String? _validateemail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email is required';
    }
    return null;
  }

   String? _validatephoneno(String? value) {
    if (value == null || value.isEmpty) {
      return 'phone no. is required';
    }
    return null;
  }

  // Function to save address to Firestore
  Future<void> addAddressToFirestore(AddressModel newAddress) async {
     var emaill=FirebaseAuth.instance.currentUser!.email;
    try {
      await FirebaseFirestore.instance.collection('addresses').add({
        'pinCode': newAddress.pinCode,
        'user_name': newAddress.user_name,
        'address': newAddress.address,
        'landmark': newAddress.landmark,
        'addressType': newAddress.addressType,
        'email': emaill,
        'phone':newAddress.phone,

      });
      print('Address added successfully!');
    } catch (e) {
      print('Failed to add address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 251, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add address'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _pinCodeController,
                        decoration: InputDecoration(
                          labelText: 'Pin Code*',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validatePinCode, // Validation
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle use my location
                      },
                      icon: Icon(Icons.location_on),
                      label: Text('Location'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter your name*',
                    hintText: 'First and Last name',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateName, // Validation
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'email*',
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateemail, // Validation
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address*',
                    hintText: 'Apartment / house number, Street, area',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateAddress, // Validation
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _landmarkController,
                  decoration: InputDecoration(
                    labelText: 'Landmark*',
                    hintText: 'Enter a nearby landmark',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateLandmark, // Validation
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phonenoController,
                  decoration: InputDecoration(
                    labelText: 'phone*',
                    hintText: 'Phone No.',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatephoneno, // Validation
                ),
                SizedBox(height: 16),
                Text(
                  'Save address as',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChoiceChip(
                      label: Text('Home'),
                      selected: _addressType == 'Home',
                      onSelected: (selected) {
                        setState(() {
                          _addressType = 'Home';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text('Work'),
                      selected: _addressType == 'Work',
                      onSelected: (selected) {
                        setState(() {
                          _addressType = 'Work';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: Text('Other'),
                      selected: _addressType == 'Other',
                      onSelected: (selected) {
                        setState(() {
                          _addressType = 'Other';
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 22),
                Text(
                  'You will receive a confirmation call on the following number',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text("+91 8848563409"), // Display phone number
                SizedBox(height: 50),
                Center(
  child: ElevatedButton(
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        // Create an AddressModel instance here with data from controllers
        AddressModel newAddress = AddressModel(
          pinCode: _pinCodeController.text,
          user_name: _nameController.text,
          address: _addressController.text,
          landmark: _landmarkController.text,
          addressType: _addressType,
          email:_emailController.text,
          phone:_phonenoController.text,
          
        );

        // Save to Firestore
        addAddressToFirestore(newAddress).then((_) {
          // Navigate to the payment option screen with newAddress as a map
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentOptionScreen(
                items: widget.items,
                newAddress: newAddress.toMap(), // Convert to Map<String, dynamic>
                totalAmt: widget.totalAmt,
              ),
            ),
          );
        });
      }
    },
    child: Text(
      'Save address',
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
