import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath = path.join(appDocumentsDir.path, "databases", "eShop.db");
    return databaseFactory.openDatabase(dbPath);
  }
}
