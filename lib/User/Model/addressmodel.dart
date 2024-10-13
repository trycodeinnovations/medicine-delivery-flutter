class AddressModel {
  final String pinCode;
  final String user_name;
  final String address;
  final String landmark;
  final String addressType;
  final String email;
  final String phone;

  AddressModel({
    required this.pinCode,
    required this.user_name,
    required this.address,
    required this.landmark,
    required this.addressType,
    required this.email,
    required this.phone
  });

  // Convert AddressModel to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'pinCode': pinCode,
      'user_name': user_name,
      'address': address,
      'landmark': landmark,
      'addressType': addressType,
      'email':email,
      'phone':phone,
    };
  }
}
