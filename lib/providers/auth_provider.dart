import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/db_helper.dart';
import '/constants/constants.dart';

class AuthProvider with ChangeNotifier {
  static String? currentUserId;
  static String? currentUserRole;
  static String? currentUsername;

  bool get isAuth {
    return currentUserId != null;
  }

  Future<bool> createAccount({
    required String username,
    required String email,
    required String password,
  }) async {
    var db = await DBHelper.getDatabase();
    await db.execute(MySqlQueries.createUsersTableQuery);
    final users = await db.query('Users', where: 'email=?', whereArgs: [email]);
    if (users.isNotEmpty) {
      return false;
    }
    final values = {
      'userId': const Uuid().v1(),
      'userName': username,
      'email': email,
      'password': password,
      'role': 'user',
    };
    await db.insert(
      'Users',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'userId': values['userId'],
      'role': values['role'],
      'userName': values['userName'],
    });
    prefs.setString('userData', userData);
    currentUserId = values['userId'];
    currentUserRole = values['role'];
    currentUsername = values['userName'];
    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    var db = await DBHelper.getDatabase();
    final users = await db.query(
      'Users',
      where: 'email=? AND password=?',
      whereArgs: [email, password],
    );
    if (users.isNotEmpty) {
      currentUserId = users.first['userId'] as String;
      currentUserRole = users.first['role'] as String;
      currentUsername = users.first['userName'] as String;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': currentUserId,
        'role': currentUserRole,
        'userName': currentUsername,
      });
      prefs.setString('userData', userData);
      return true;
    }
    return false;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    currentUserId = userData['userId'];
    currentUserRole = userData['role'];
    currentUsername = userData['userName'];
    notifyListeners();
    return true;
  }

  void logout() async {
    currentUserId = null;
    currentUserRole = null;
    currentUsername = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
