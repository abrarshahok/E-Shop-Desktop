import 'package:flutter/material.dart';

Widget notFound(String label) {
  return Center(
    child: Text(
      label,
      style: MyFonts.getFont(
        color: MyColors.primaryColor,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

AppBar appBar(String title, {bool center = false}) {
  return AppBar(
    elevation: 0,
    centerTitle: center,
    iconTheme: const IconThemeData(color: Colors.black),
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: MyFonts.getFont(
        fontSize: 20,
        color: MyColors.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class MyFonts {
  static TextStyle getFont({
    FontWeight? fontWeight = FontWeight.normal,
    required Color color,
    required double fontSize,
  }) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: fontWeight,
      color: color,
      fontSize: fontSize,
    );
  }
}

class MyColors {
  static const primaryColor = Color(0xFF4C4E4E);
  static const secondaryColor = Colors.white;
}

class MyIcons {
  static const allProducts = 'assets/images/show_all.png';
  static const manageProducts = 'assets/images/manage.png';
  static const lock = 'assets/images/lock.png';
  static const admin = 'assets/images/admin.png';
  static const user = 'assets/images/user.png';
  static const cart = 'assets/images/cart.png';
  static const orders = 'assets/images/orders.png';
}

class MyImages {
  static const iphone = 'assets/images/iphone.png';
  static const macbook = 'assets/images/macbook.jpg';
  static const laptop = 'assets/images/laptop.png';
  static const android = 'assets/images/android.jpeg';
}

class MySqlQueries {
  static const String createProductTableQuery =
      '''CREATE TABLE IF NOT EXISTS Products(
        productId TEXT PRIMARY KEY,
        productName TEXT NOT NULL,
        productCategory TEXT NOT NULL,
        productImageLocation TEXT NOT NULL,
        productPrice REAL NOT NULL,
        productStock INT NOT NULL
      )''';

  static const String createOrdersTableQuery =
      '''CREATE TABLE IF NOT EXISTS Orders(
        orderId TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        customerName TEXT NOT NULL,
        customerAddress TEXT NOT NULL,
        amount REAL NOT NULL,
        orderStatus INT NOT NULL,
        dateTime TEXT NOT NULL,
        products TEXT NOT NULL
      )''';

  static const String createCartTableQuery = '''CREATE TABLE IF NOT EXISTS Cart(
        cartId TEXT,
        cartItemId TEXT,
        productName TEXT NOT NULL,
        productImageLocation TEXT NOT NULL,
        totalPrice REAL NOT NULL,
        productQuantity INT NOT NULL
      )''';

  static const String createUsersTableQuery =
      '''CREATE TABLE IF NOT EXISTS Users(
      userId TEXT PRIMARY KEY,
      userName TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      role TEXT NOT NULL
    )''';
}
