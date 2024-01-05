import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '/models/cart_item.dart';
import '/helpers/db_helper.dart';
import '/models/order_item.dart';
import '/constants/constants.dart';
import '/providers/auth_provider.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get allOrders {
    return [..._orders];
  }

  int get itemCount => _orders.length;

  Future<void> fetchUserOrders() async {
    try {
      final db = await DBHelper.getDatabase();
      await db.execute(MySqlQueries.createOrdersTableQuery);
      var fetchedOrders = await db.query('Orders',
          where: 'userId=?', whereArgs: [AuthProvider.currentUserId]);
      _orders = fetchedOrders.map<OrderItem>((order) {
        return OrderItem(
          id: order['orderId'].toString(),
          amount: double.parse(order['amount'].toString()),
          customerName: order['customerName'].toString(),
          customerAddress: order['customerAddress'].toString(),
          dateTime: DateTime.parse(order['dateTime'].toString()),
          isDelivered: (order['orderStatus'] as int) == 0 ? false : true,
          products: (json.decode(order['products'] as String) as List<dynamic>)
              .map((cartItem) {
            return CartItem(
              id: cartItem['id'].toString(),
              title: cartItem['title'].toString(),
              image: cartItem['image'].toString(),
              price: double.parse(cartItem['price'].toString()),
              quantity: int.parse(cartItem['quantity'].toString()),
            );
          }).toList(),
        );
      }).toList();
      _orders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchAllOrdersForAdmin() async {
    try {
      final db = await DBHelper.getDatabase();
      await db.execute(MySqlQueries.createOrdersTableQuery);
      var fetchedOrders = await db.query('Orders');
      _orders = fetchedOrders.map<OrderItem>((order) {
        return OrderItem(
          id: order['orderId'].toString(),
          customerName: order['customerName'].toString(),
          customerAddress: order['customerAddress'].toString(),
          amount: double.parse(order['amount'].toString()),
          dateTime: DateTime.parse(order['dateTime'].toString()),
          isDelivered: (order['orderStatus'] as int) == 0 ? false : true,
          products: (json.decode(order['products'] as String) as List<dynamic>)
              .map((cartItem) {
            return CartItem(
              id: cartItem['id'].toString(),
              title: cartItem['title'].toString(),
              image: cartItem['image'].toString(),
              price: double.parse(cartItem['price'].toString()),
              quantity: int.parse(cartItem['quantity'].toString()),
            );
          }).toList(),
        );
      }).toList();
      _orders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  List<OrderItem> get deliveredOrders =>
      _orders.where((order) => order.isDelivered).toList();
  List<OrderItem> get pendingOrders =>
      _orders.where((order) => !order.isDelivered).toList();

  double get pendingEarning {
    double total = 0.0;
    for (var order in _orders) {
      if (!order.isDelivered) {
        total += order.amount;
      }
    }
    return total;
  }

  double get earningInAccount {
    double total = 0.0;
    for (var order in _orders) {
      if (order.isDelivered) {
        total += order.amount;
      }
    }
    return total;
  }

  Future<void> addOrder({
    required String customerName,
    required String customerAddress,
    required double totalPrice,
    required List<CartItem> cartItems,
  }) async {
    try {
      final db = await DBHelper.getDatabase();
      final order = OrderItem(
        id: const Uuid().v1(),
        customerName: customerName,
        customerAddress: customerAddress,
        amount: totalPrice,
        dateTime: DateTime.now(),
        products: cartItems,
        isDelivered: false,
      );
      final values = {
        'orderId': order.id,
        'userId': AuthProvider.currentUserId,
        'customerName': order.customerName,
        'customerAddress': order.customerAddress,
        'amount': order.amount,
        'orderStatus': order.isDelivered ? 1 : 0,
        'dateTime': order.dateTime.toIso8601String(),
        'products': json.encode(cartItems.map((item) => item.toMap()).toList()),
      };
      await db.insert('Orders', values);
      _orders.insert(0, order);
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> changeOrderStatus({
    required String orderId,
    required int status,
  }) async {
    try {
      final db = await DBHelper.getDatabase();
      await db.update('Orders', {'orderStatus': status},
          where: 'orderId=?', whereArgs: [orderId]);
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }
}
