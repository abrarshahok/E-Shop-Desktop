import 'package:e_shop_desktop/constants/constants.dart';
import 'package:e_shop_desktop/helpers/db_helper.dart';
import 'package:e_shop_desktop/models/product.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _productsList = [];
  List<Product> get productsList {
    return [..._productsList];
  }

  Categories getItemCategory(String category) {
    Categories choosenCategory = switch (category) {
      'iphone' => Categories.iphone,
      'android' => Categories.android,
      'laptop' => Categories.laptop,
      'macbook' => Categories.macbook,
      _ => Categories.unknown,
    };
    return choosenCategory;
  }

  Future<void> fetchProductsInfo() async {
    try {
      final db = await DBHelper.getDatabase();
      await db.execute(MySqlQueries.createProductTableQuery);
      var fetchedProducts = await db.query('Products');
      List<Product> fetchedProductList = [];
      insertFetchedProducts(fetchedProducts, fetchedProductList);
      _productsList = fetchedProductList;
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addProduct({
    required String productId,
    required String productName,
    required String productCategory,
    required String productImageLocation,
    required double productPrice,
    required int productStock,
  }) async {
    try {
      final db = await DBHelper.getDatabase();

      final values = {
        'productId': productId,
        'productName': productName,
        'productCategory': productCategory,
        'productImageLocation': productImageLocation,
        'productPrice': productPrice,
        'productStock': productStock,
      };

      await db.insert('Products', values);
      _productsList.insert(
        0,
        Product(
          productId: productId,
          productName: productName,
          productCategory: getItemCategory(productCategory),
          productImageLocation: productImageLocation,
          productPrice: productPrice,
          productStock: productStock,
        ),
      );
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateProduct({
    required String productId,
    required String productName,
    required String productCategory,
    required String productImageLocation,
    required double productPrice,
    required int productStock,
  }) async {
    try {
      final db = await DBHelper.getDatabase();
      final values = {
        'productId': productId,
        'productName': productName,
        'productCategory': productCategory,
        'productImageLocation': productImageLocation,
        'productPrice': productPrice,
        'productStock': productStock,
      };

      await db.update('Products', values,
          where: 'productId=?', whereArgs: [productId]);
      final currentIndex =
          _productsList.indexWhere((pr) => pr.productId == productId);
      _productsList[currentIndex] = Product(
        productId: productId,
        productName: productName,
        productCategory: getItemCategory(productCategory),
        productImageLocation: productImageLocation,
        productPrice: productPrice,
        productStock: productStock,
      );
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  List<Product> getCategoryProducts(Categories category) {
    return _productsList
        .where((product) => product.productCategory == category)
        .toList();
  }

  Product findById(String id) {
    return _productsList.firstWhere((product) => product.productId == id);
  }

  void searchProduct(String productName, String category) async {
    if (productName.trim() == '') {
      fetchProductsInfo();
      return;
    }
    final db = await DBHelper.getDatabase();
    final fetchedProducts = await db.query(
      'Products',
      where: 'productName LIKE ? AND productCategory = ?',
      whereArgs: ['%$productName%', category],
    );
    List<Product> fetchedProductList = [];
    insertFetchedProducts(fetchedProducts, fetchedProductList);
    _productsList = fetchedProductList;
    notifyListeners();
  }

  void insertFetchedProducts(
    List<Map<String, Object?>> fetchedProducts,
    List<Product> fetchedProductList,
  ) {
    fetchedProducts.map((product) {
      fetchedProductList.insert(
        0,
        Product(
          productId: product['productId'] as String,
          productName: product['productName'] as String,
          productCategory:
              getItemCategory(product['productCategory'] as String),
          productImageLocation: product['productImageLocation'] as String,
          productPrice: double.parse(product['productPrice'].toString()),
          productStock: int.parse(product['productStock'].toString()),
        ),
      );
    }).toList();
  }

  Future<void> deleteProduct(String productId) async {
    try {
      var db = await DBHelper.getDatabase();
      db.delete(
        'Products',
        where: 'productId=?',
        whereArgs: [productId],
      );
      _productsList.removeWhere((pr) => pr.productId == productId);
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }
}
