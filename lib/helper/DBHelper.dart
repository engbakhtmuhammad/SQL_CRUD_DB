import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'users.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, age INTEGER)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data);
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> deleteData(String table, String id) async {
    final db = await DBHelper.database();

    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateData(
      String table, String id, Map<String, Object> data) async {
    final db = await DBHelper.database();

    db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }
}
