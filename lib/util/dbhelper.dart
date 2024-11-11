import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../model/contact.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblContact = "contact";
  String colId = "id";
  String colName = "name";
  String colPhone = "phone";
  String colEmail = "email";

  DbHelper._internal();
  factory DbHelper() => _dbHelper;

  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db!;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "contacts.db";
    var dbContacts = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbContacts;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblContact($colId INTEGER PRIMARY KEY, $colName TEXT, $colPhone TEXT, $colEmail TEXT)");
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await this.db;
    return await db.insert(tblContact, contact.toMap());
  }

  Future<List> getContacts() async {
    Database db = await this.db;
    return await db.rawQuery("SELECT * FROM $tblContact");
  }

  Future<int> updateContact(Contact contact) async {
    var db = await this.db;
    return await db.update(tblContact, contact.toMap(),
        where: "$colId = ?", whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    var db = await this.db;
    return await db.rawDelete('DELETE FROM $tblContact WHERE $colId = $id');
  }
}
