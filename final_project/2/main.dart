import 'dart:async';
import 'dart:isolate';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

enum Categori { shooter, mmofps, pvp, mmorpg }

void main() async {

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}



class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedCategori = '';
  Categori selected = null;


  @override
  void initState() {
    super.initState();
    setCategori();
  }

  onChange(Categori value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int categori;
    setState(() {
      switch (value) {
        case Categori.shooter:
          categori = 1;
          selectedCategori = 'shooter';
          break;
        case Categori.mmofps:
          categori = 2;
          selectedCategori = 'mmofps';
          break;
        case Categori.pvp:
          categori = 3;
          selectedCategori = 'pvp';
          break;
        case Categori.mmorpg:
          categori = 4;
          selectedCategori = 'mmorpg';
          break;
      }
      prefs.setInt('category', categori);

      selected = value;
    });
  }

  setCategori() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switch (prefs.getInt('category') ?? 0) {
        case 0:
          selected = Categori.pvp;
          selectedCategori = 'pvp';
          break;
        case 1:
          selected = Categori.shooter;
          selectedCategori = 'shooter';
          break;
        case 2:
          selected = Categori.mmofps;
          selectedCategori = 'mmofps';
          break;
        case 3:
          selected = Categori.pvp;
          selectedCategori = 'pvp';
          break;
        case 4:
          selected = Categori.mmorpg;
          selectedCategori = 'mmorpg';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void handleClick(String value) async {
      switch (value) {
        case 'Settings':
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Settings(kategori: selected)),
          );
          setState(() {

            selected = result;
            onChange(selected);
          });
      }
    }

    return MaterialApp(


      home: Scaffold(
        appBar: AppBar(
          title: Text('Games'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (context) {
                return {'Settings'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Myapp(category: selectedCategori),
      ),
    );
  }
}



class Myapp extends StatefulWidget {
  String category;
  Myapp({Key key, @required this.category}) : super(key: key);
  _JSONListView createState() => _JSONListView();
}


class _JSONListView extends State<Myapp> {
  final dbHelper = DatabaseHelper.instance;
  String urlExtension = '';
  String url = 'https://www.freetogame.com/api/games/';


  List categoryName = [
    'pvp',
    'shooter',
    'mmofps',
    'mmorpg'];

  @override
  void initState() {
    super.initState();
    loadData();
  }



  void transferTables(List data, String table) async {

    await dbHelper.deleteTable(table);

    data.forEach((game) async {
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: game["title"],
        DatabaseHelper.columnId: game["id"],
      };
      await dbHelper.insertDataBase(row, table);
    });
  }

  Future<void> loadData() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;
    categoryName.forEach((category) async {
      if (category != '') {
        urlExtension = url + "?category=" + category;
      } else {
        urlExtension = url;
      }
      List msg = await sendReceive(
        sendPort,
        urlExtension,
      );
      setState(() {
        transferTables(msg, category);
      });
    });
  }


  static Future<void> dataLoader(SendPort sendPort) async {

    ReceivePort port = ReceivePort();
    sendPort.send(port.sendPort);
    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];
      String dataURL = data;
      http.Response response = await http.get(dataURL);
      replyTo.send(jsonDecode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
        future: dbHelper.games(widget.category),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child:
              Text("Fatal Error"),
            );
          } else if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator()
            );
          } else {
            int builder_length = 0;
            if (snapshot.data.length > 10) {builder_length = 10;
            } else {builder_length = snapshot.data.length;}
            return ListView.separated(
              itemCount: builder_length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.black,
                    child: ListTile(
                      title: Text(snapshot.data[index].title,style: TextStyle(
                          color: Colors.white, fontSize: 15),textAlign: TextAlign.center,),
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}


class Settings extends StatefulWidget {
  final Categori kategori;

  Settings({Key key, @required this.kategori})
      : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Categori wanted = null;

  @override
  Widget build(BuildContext context) {
    if (wanted == null) {
      wanted = widget.kategori;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Selection Page"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(

              leading: Radio(
                groupValue: wanted,
                value: Categori.shooter,
                onChanged: (Categori value) {
                  setState(() {
                    wanted = value;
                  });
                },
              ),
              title:  Text('Shooter Category',softWrap: true,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(

              leading: Radio(
                groupValue: wanted,
                value: Categori.mmofps,
                onChanged: (Categori value) {
                  setState(() {
                    wanted = value;
                  });
                },
              ),
              title:
              Text('Massively Multiplayer Online FirstPerson Shooter Category',softWrap: true,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(

              leading: Radio(
                groupValue: wanted,
                value: Categori.pvp,
                onChanged: (Categori value) {
                  setState(() {
                    wanted = value;
                  });
                },
              ),
              title:  Text('Player versus Player',softWrap: true,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(

              leading: Radio(
                value: Categori.mmorpg,
                groupValue: wanted,
                onChanged: (Categori value) {
                  setState(() {
                    wanted = value;
                  });
                },
              ),
              title:  Text('Massively Multiplayer Online Role-Playing Game Category',softWrap: true,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white)),
              color: Colors.black,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(7.0),
              splashColor: Colors.blue,
              onPressed: () {

                if (wanted == null) {
                  wanted = widget.kategori;
                }
                Navigator.pop(context, wanted);
              },
              child: Text('Confirm' ,style: TextStyle(fontSize: 19.0),softWrap: true,),
            ),
          ),
        ],
      ),
    );
  }
}


class DatabaseHelper {
  static Database _database;
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;

  List categories =
  ['pvp',
    'shooter',
    'mmofps',
    'mmorpg'];

  static final columnId = 'id';
  static final columnName = 'name';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }


  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }


  Future _onCreate(Database db, int version) {
    categories.forEach((category) async {
      await db.execute('''
          CREATE TABLE $category (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL
          )
          ''');
    });
  }

  Future<int> insertDataBase(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    print('inserted row: $row');
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryTable(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<void> deleteTable(String table) async {
    Database db = await instance.database;
    await db.rawQuery("DELETE FROM $table");

  }

  Future<List<Data>> games(String table) async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> map = await db.query(table);
    return List.generate(map.length, (i) {
      return Data(
        id: map[i][columnId],
        title: map[i][columnName],
      );
    });
  }
}



class Data {
  String title;
  int id;

  Data({this.title, this.id,});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      title: json['title'],
      id: json['id'],
    );
  }
}
