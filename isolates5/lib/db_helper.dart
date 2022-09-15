import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table1 = 'shooter';
  static final table2 = 'mmofps';
  static final table3 = 'pvp';
  static final table4 = 'mmorpg';



  static final columnId = '_id';
  static final columnName = 'name';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table1 (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL
            
          )
          ''');
    await db.execute('''
          CREATE TABLE $table2 (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL
            
          )
          ''');
    await db.execute('''
          CREATE TABLE $table3 (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL
            
          )
          ''');
    await db.execute('''
          CREATE TABLE $table4 (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL
            
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert1(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table1, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows1() async {
    Database db = await instance.database;
    return await db.query(table1);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount1() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table1'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update1(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table1, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete1(int id) async {
    Database db = await instance.database;
    return await db.delete(table1, where: '$columnId = ?', whereArgs: [id]);
  }

  ///////////////////////////////////////////////////////////////////////////

  Future<int> insert2(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('data inserted SUCCESFULLY');
    return await db.insert(table2, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows2() async {
    Database db = await instance.database;
    return await db.query(table2);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount2() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table2'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update2(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table2, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete2(int id) async {
    Database db = await instance.database;
    return await db.delete(table2, where: '$columnId = ?', whereArgs: [id]);
  }
  ///////////////////////////////////////////////////////////////////////////

  Future<int> insert3(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('data inserted SUCCESFULLY');
    return await db.insert(table3, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows3() async {
    Database db = await instance.database;
    return await db.query(table3);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount3() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table3'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update3(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table3, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete3(int id) async {
    Database db = await instance.database;
    return await db.delete(table3, where: '$columnId = ?', whereArgs: [id]);
  }
  ///////////////////////////////////////////////////////////////////////////

  Future<int> insert4(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('data inserted SUCCESFULLY');
    return await db.insert(table4, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows4() async {
    Database db = await instance.database;
    return await db.query(table4);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount4() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table4'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update4(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table4, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete4(int id) async {
    Database db = await instance.database;
    return await db.delete(table4, where: '$columnId = ?', whereArgs: [id]);
  }
}