import 'dart:async';
import 'package:sqflite/sqflite.dart';

abstract class DB {

  static Database _db;

  static String tableProduct = 'PRODUCTS';

  static int get _version => 1;

  static Future<void> init() async {

    if (_db != null) { return; }

    try {
      String _path = await getDatabasesPath() + 'db_user.sqlite';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch(ex) {
      print(ex);
    }
  }

  static Database getDB() {
    return _db;
  }

  static void onCreate(Database db, int version) async {

    await db.execute(
      'CREATE TABLE PRODUCTS('
          'ID INTEGER PRIMARY KEY AUTOINCREMENT,'
          'EMAIL_USER TEXT,'
          'ID_STORE TEXT,'
          'ID_PRODUCT TEXT,'
          'AMOUNT INTEGER'
       ');'
    );
  }

  static Future<List<Map<String, dynamic>>> find(String table, String where) async =>
    _db.query(table, where: where);

  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  static Future<int> insert(String table, dynamic model) async =>
      await _db.insert(table, model.toMap());


  static Future<int> update(String table, dynamic model, String where) async =>
      await _db.update(table, model.toMap(), where: where , whereArgs: [model.id]);

  static Future<int> delete(String table, String where) async =>
      await _db.delete(table, where: where);

  static Future<int> deleteAll(String table) async =>
      await _db.delete(table);

}
