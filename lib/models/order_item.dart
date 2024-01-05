import 'cart_item.dart';
import 'package:flutter/material.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final String customerName;
  final String customerAddress;
  final List<CartItem> products;
  final DateTime dateTime;
  bool isDelivered;

  OrderItem({
    required this.id,
    required this.amount,
    required this.customerName,
    required this.customerAddress,
    required this.products,
    required this.dateTime,
    this.isDelivered = false,
  });

  void toggleStatus(bool status) {
    isDelivered = status;
    notifyListeners();
  }
}
