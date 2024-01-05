enum Categories { laptop, macbook, android, iphone, unknown }

class Product {
  final String productId;
  final String productName;
  final Categories productCategory;
  final String productImageLocation;
  final double productPrice;
  final int productStock;

  Product({
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productImageLocation,
    required this.productPrice,
    required this.productStock,
  });
}
