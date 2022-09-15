
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MyApp()
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final nav = GlobalKey<NavigatorState>();
  String information;
  SharedPreferences prefs;

  void updateInfo(String informatione) {
    setState(() {
      information = informatione;
      _saveInfo(information);
    });
  }

  void move() async {
    final information = await nav.currentState
        .push(MaterialPageRoute(builder: (context) => Setting()));

    setState(() {
      updateInfo(information);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInfo();
  }

  _loadInfo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      information = (prefs.getString('information'));
    });

    if (information == null)
      setState(() {
        information = "pvp";
      });
  }

  _saveInfo(String informationa) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('information', informationa);
  }

  @override
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signInAnonymously();
    print("Category: " + information.toString());
    return MaterialApp(
        navigatorKey: nav,
        home: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Settings"),
                  ),
                ],
                onSelected: (int selection) async {
                  if (selection == 1) {
                    //navigator.currentState.push(
                    //  MaterialPageRoute(builder: (context) => Setting()));
                    move();
                  }
                },
              ),
            ],
            title: Center(
              child: Text("Free To Play Games Database"),
            ),
          ),
          body: Container(
            child: StreamBuilder(

              stream: getUsersInRoom(information != null ? information : "pvp"),

              builder: (context, result) {
                if (result.hasData) {
                  var usersInRoom = result.data;

                  return ListView.builder(

                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Text(result.data[index].id.toString()),
                              title: Text(result.data[index].name),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                          itemCount: usersInRoom.length);
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ));
  }
}

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {


  int check;
  String categ;
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCheck();
  }

  _loadCheck() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      check = (prefs.getInt('check'));
    });
  }

  _saveCheck(int check) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('check', check);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Column(
          children: [
            RadioListTile<int>(
              value: 1,
              groupValue: check,
              onChanged: (value) {
                setState(() {
                  check = value;
                  _saveCheck(check);
                  categ = "shooter";
                  // prefs.setInt('check', _check);
                });
              },
              title: Text("Shooter"),
            ),
            RadioListTile<int>(
              value: 2,
              groupValue: check,
              onChanged: (value) {
                setState(() {
                  check = value;
                  _saveCheck(check);
                  categ = "mmofps";
                  //  prefs.setInt('check', _check);
                });
              },
              title: Text("Massively Multiplayer Online First-Person Shooter"),
            ),
            RadioListTile<int>(
              value: 3,
              groupValue: check,
              onChanged: (value) {
                setState(() {
                  check = value;
                  _saveCheck(check);
                  categ = "pvp";

                  // prefs.setInt('check', _check);
                });
              },
              title: Text("Player versus Player"),
            ),
            RadioListTile<int>(
              value: 4,
              groupValue: check,
              onChanged: (value) {
                setState(() {
                  check = value;
                  _saveCheck(check);
                  categ = "mmorpg";
                  // prefs.setInt('check', _check);
                });
              },
              title: Text("Massively Multiplayer Online Role-Playing Game"),
            ),
            FlatButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context, categ);
                },
                child: Text("OK")),
          ],
        ),
      ),
    );
  }
}

class Games {
  int id;
  final String name;

  Games({this.name, this.id});

  factory Games.fromJson(Map<String, dynamic> json) {
    return Games(
      name: json['name'] as String,
      id: json['id'],
    );
  }
}


final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

Stream<List<Games>> getUsersInRoom(String game) {
  var snapShot =
  _firebaseDB.collection("games").doc(game).collection(game).snapshots();

  return snapShot
      .map((event) => event.docs.map((e) => Games.fromJson(e.data())).toList());
}