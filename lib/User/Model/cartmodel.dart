class CartItem {
  String id;
  String item_name;
  double price;
  int quantity;
  String imageUrl;

  CartItem({
    required this.id,
    required this.item_name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': item_name,
      'quantity': quantity,
      'price': price,
      'imageUrl':imageUrl
    };
  }

  double getTotalPrice() {
    return price * quantity;
  }
}

class Cart {
  List<CartItem> items = [];

  // Add item to the cart
  void addItem(CartItem item) {
    items.add(item);
  }

  // Get total amount
  double getTotalAmount() {
    return items.fold(0, (sum, item) => sum + item.getTotalPrice());
  }
}
