import 'package:e_shop_desktop/constants/constants.dart';
import 'package:flutter/foundation.dart';
import '/helpers/db_helper.dart';
import '../models/cart_item.dart';
import '/providers/auth_provider.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _cartItems = {};
  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  bool cartContainsElement(id) => _cartItems.containsKey(id);

  int get itemsCount => _cartItems.length;

  double get total {
    double total = 0.0;
    _cartItems.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  Future<void> fetchCartItems() async {
    _cartItems.clear();
    final db = await DBHelper.getDatabase();
    await db.execute(MySqlQueries.createCartTableQuery);
    var fetchedCartItems = await db.query('Cart',
        where: 'cartItemId=?', whereArgs: [AuthProvider.currentUserId]);
    fetchedCartItems.map((cart) {
      _cartItems.putIfAbsent(
        cart['cartId'].toString(),
        () => CartItem(
          id: cart['cartItemId'].toString(),
          title: cart['productName'].toString(),
          image: cart['productImageLocation'].toString(),
          price: double.parse(cart['totalPrice'].toString()),
          quantity: int.parse(cart['productQuantity'].toString()),
        ),
      );
    }).toList();

    notifyListeners();
  }

  void addItem({
    required String productId,
    required String title,
    required String imageUrl,
    required double price,
  }) async {
    final db = await DBHelper.getDatabase();
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (item) => CartItem(
          id: item.id,
          title: item.title,
          image: item.image,
          price: item.price,
          quantity: item.quantity + 1,
        ),
      );
      final currentItem = _cartItems[productId];
      final values = {
        'cartId': productId,
        'cartItemId': currentItem!.id,
        'productName': title,
        'productImageLocation': imageUrl,
        'totalPrice': price,
        'productQuantity': currentItem.quantity,
      };
      await db.update('Cart', values,
          where: 'cartId=? AND cartItemId=?',
          whereArgs: [productId, AuthProvider.currentUserId]);
    } else {
      final values = {
        'cartId': productId,
        'cartItemId': AuthProvider.currentUserId,
        'productName': title,
        'productImageLocation': imageUrl,
        'totalPrice': price,
        'productQuantity': 1,
      };
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          id: AuthProvider.currentUserId!,
          title: title,
          image: imageUrl,
          price: price,
          quantity: 1,
        ),
      );
      await db.insert('Cart', values);
    }
    notifyListeners();
  }

  void removeItem({required String productId}) async {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    final db = await DBHelper.getDatabase();

    try {
      if (_cartItems[productId]!.quantity > 1) {
        _cartItems.update(
          productId,
          (item) => CartItem(
            id: item.id,
            title: item.title,
            image: item.image,
            price: item.price,
            quantity: item.quantity - 1,
          ),
        );
        final currentItem = _cartItems[productId];
        final values = {
          'cartId': productId,
          'cartItemId': currentItem!.id,
          'productName': currentItem.title,
          'productImageLocation': currentItem.image,
          'totalPrice': currentItem.price,
          'productQuantity': currentItem.quantity,
        };
        await db.update('Cart', values,
            where: 'cartId=? AND cartItemId=?',
            whereArgs: [productId, AuthProvider.currentUserId]);
      } else {
        await db.delete('Cart',
            where: 'cartId=? AND cartItemId=?',
            whereArgs: [productId, AuthProvider.currentUserId]);
        _cartItems.remove(productId);
      }
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  deleteItemFromCart(String productId) async {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    final db = await DBHelper.getDatabase();
    final currentItem = _cartItems[productId];
    try {
      await db.delete('Cart',
          where: 'cartId=? AND cartItemId=?',
          whereArgs: [productId, AuthProvider.currentUserId]);
      _cartItems.remove(productId);
    } catch (_) {
      _cartItems[productId] = currentItem!;
      rethrow;
    }
    notifyListeners();
  }

  void clearCart() async {
    final db = await DBHelper.getDatabase();
    try {
      for (String productId in _cartItems.keys) {
        final quantity = _cartItems[productId]!.quantity;
        _minusStock(productId, quantity);
        await db.delete('Cart',
            where: 'cartId=? AND cartItemId=?',
            whereArgs: [productId, AuthProvider.currentUserId]);
      }
      _cartItems.clear();
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  void _minusStock(String id, int quantity) async {
    final db = await DBHelper.getDatabase();
    List<Map<String, dynamic>> products =
        await db.query('Products', where: 'productId=?', whereArgs: [id]);
    if (products.isNotEmpty) {
      var currentProductInfo = products.first;
      int currentStock = currentProductInfo['productStock'];
      int updatedStock = currentStock - quantity;
      await db.update('Products', {'productStock': updatedStock},
          where: 'productId=?', whereArgs: [id]);
      notifyListeners();
    }
  }
}
