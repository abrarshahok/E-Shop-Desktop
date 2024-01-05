class CartItem {
  final String id;
  final String title;
  final String image;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}
