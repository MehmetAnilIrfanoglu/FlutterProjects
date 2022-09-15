import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'db_helper.dart';

void main() {
  runApp(SampleApp());
}


class Constants {
  static const String Settings = 'Settings';

  static const List<String> choices = <String>[
    Settings,
  ];
}

class SampleApp extends StatelessWidget {

  static String option = "pvp"; //Default
  static String title ="Player versus Player"; //Default

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);
  static final dbHelper = DatabaseHelper.instance;
  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {

  List denem1 =[];
  List denem2 = [];
  List denem3=[];
  List denem4=[];
  @override
  void initState() {
    super.initState();

    getShared();
    loadData().then((value) {});
  }

  Future<void> loadData() async {

    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message
    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(
      sendPort,
      "https://www.freetogame.com/api/games?category=${SampleApp.option}",
    );

    if(SampleApp.option=='pvp'){
      insert1(msg).then((value) {
        setState(() {});
      });
    }
    if(SampleApp.option=='shooter'){
      insert2(msg).then((value) {

        setState(() {});
      });
    }
    if(SampleApp.option=='mmorpg'){
      insert3(msg).then((value) {

        setState(() {});
      });
    }
    if(SampleApp.option=='mmofps'){
      insert4(msg).then((value) {

        setState(() {});
      });
    }
  }

  Future insert1(List<dynamic> liste) async {

    for (int i=0;i<10;i++) {

      Map<String, dynamic> row = {
        DatabaseHelper.columnName: liste[i]["title"],
      };
      final id = await SampleAppPage.dbHelper.insert1(row);
      print('table 1: inserted row id: $id');
    }

  }
  Future insert2(List<dynamic> liste) async {
    for (int i=0;i<10;i++) {

      Map<String, dynamic> row = {
        DatabaseHelper.columnName: liste[i]["title"],
      };
      final id = await SampleAppPage.dbHelper.insert2(row);
      print('table 2: inserted row id: $id');
    }

  }
  Future insert3(List<dynamic> liste) async {
    for (int i=0;i<10;i++) {

      Map<String, dynamic> row = {
        DatabaseHelper.columnName: liste[i]["title"],
      };
      final id = await SampleAppPage.dbHelper.insert3(row);
      print('table 3: inserted row id: $id');
    }

  }
  Future insert4(List<dynamic> liste) async {
    for (int i=0;i<10;i++) {

      Map<String, dynamic> row = {
        DatabaseHelper.columnName: liste[i]["title"],
      };
      final id = await SampleAppPage.dbHelper.insert4(row);
      print('table 4: inserted row id: $id');
    }

  }
  Future<List> query1() async {
    denem1=[];

    final allRows = await SampleAppPage.dbHelper.queryAllRows1();
    allRows.forEach((row) => denem1.add(row['name']));
    delete1();
    return denem1;
  }
  Future<List> query2() async {
    denem2=[];

    final allRows = await SampleAppPage.dbHelper.queryAllRows2();
    allRows.forEach((row) => denem2.add(row['name']));
    delete2();
    return denem2;
  }
  Future<List> query3() async {
    denem3=[];

    final allRows = await SampleAppPage.dbHelper.queryAllRows3();
    allRows.forEach((row) => denem3.add(row['name']));
    delete3();
    return denem3;
  }
  Future<List> query4() async {
    denem4=[];

    final allRows = await SampleAppPage.dbHelper.queryAllRows4();
    allRows.forEach((row) => denem4.add(row['name']));
    delete4();
    return denem4;
  }

  Future<void> delete1() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await SampleAppPage.dbHelper.queryRowCount1();
    for(int i=id;i>0;i--){
      final rowsDeleted = await SampleAppPage.dbHelper.delete1(i);
      print('deleted $rowsDeleted row(s): row $i');
    }
  }
  Future<void> delete2() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await SampleAppPage.dbHelper.queryRowCount2();
    for(int i=id;i>0;i--){
      final rowsDeleted = await SampleAppPage.dbHelper.delete2(i);
      print('deleted $rowsDeleted row(s): row $i');
    }
  }
  Future<void> delete3() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await SampleAppPage.dbHelper.queryRowCount3();
    for(int i=id;i>0;i--){
      final rowsDeleted = await SampleAppPage.dbHelper.delete3(i);
      print('deleted $rowsDeleted row(s): row $i');
    }
  }
  Future<void> delete4() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await SampleAppPage.dbHelper.queryRowCount4();
    for(int i=id;i>0;i--){
      final rowsDeleted = await SampleAppPage.dbHelper.delete4(i);
      print('deleted $rowsDeleted row(s): row $i');
    }
  }

  // the entry point for the isolate
  static Future<void> dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];

      String dataURL = data;
      http.Response response = await http.get(dataURL);
      // Lots of JSON to parse
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
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          title: new Text(SampleApp.title),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body:
        SampleApp.option=='pvp'?
        FutureBuilder<List<dynamic>>(
          future: query1(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: denem1.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          denem1[index],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            )
                : Center(child: CircularProgressIndicator());
          },
        )
            : SampleApp.option=='shooter'?
        FutureBuilder<List<dynamic>>(
          future: query2(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? denem2.isEmpty
                ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple,
                ),
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: denem2.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          denem2[index],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            )
                : Center(child: CircularProgressIndicator());
          },
        )
            :
        SampleApp.option=="mmorpg"?
        FutureBuilder<List<dynamic>>(
          future: query3(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? denem3.isEmpty
                ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple,
                ),
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: denem3.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          denem3[index],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            )
                : Center(child: CircularProgressIndicator());
          },
        ):
        SampleApp.option=='mmofps'?
        FutureBuilder<List<dynamic>>(
          future: query4(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? denem4.isEmpty
                ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple,
                ),
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: denem4.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          denem4[index],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            )
                : Center(child: CircularProgressIndicator());
          },
        )
            :
        Center(child: CircularProgressIndicator())
    );
  }
  void choiceAction(String choice) {
    if (choice == Constants.Settings) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GameData()));
    }
  }




}
getShared() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  GameData.track = pref.getInt("track") ?? 0;
}

setShared() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  await pref.setInt("track", GameData.track);
}

enum Catalog { shooter, mmofps, pvp, mmorpg }

class GameData extends StatefulWidget {
  static int track;
  static Catalog _character;

  @override
  _GameDataState createState() => _GameDataState();
}

class _GameDataState extends State<GameData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select a Category'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: <Widget>[
                  RadioListTile<Catalog>(
                    title: const Text('Shooter'),
                    value: Catalog.shooter,
                    groupValue: GameData._character,
                    onChanged: (Catalog value) {
                      setState(() {
                        GameData._character = value;

                        GameData.track = 1;
                      });
                    },
                  ),
                  RadioListTile<Catalog>(
                    title: const Text(
                        'Massively Multiplayer Online First-Person Shooter'),
                    value: Catalog.mmofps,
                    groupValue: GameData._character,
                    onChanged: (Catalog value) {
                      setState(() {
                        GameData._character = value;

                        GameData.track = 2;
                      });
                    },
                  ),
                  RadioListTile<Catalog>(
                    title: const Text('Player versus Player'),
                    value: Catalog.pvp,
                    groupValue: GameData._character,
                    onChanged: (Catalog value) {
                      setState(() {
                        GameData._character = value;

                        GameData.track = 3;
                      });
                    },
                  ),
                  RadioListTile<Catalog>(
                    title: const Text(
                        'Massively Multiplayer Online Role-Playing Game'),
                    value: Catalog.mmorpg,
                    groupValue: GameData._character,
                    onChanged: (Catalog value) {
                      setState(() {
                        GameData._character = value;

                        GameData.track = 4;
                      });
                    },
                  ),
                  Container(
                    child: Text(GameData.track.toString()),
                  )
                ],
              ),
              FlatButton(
                onPressed: () {
                  setShared();
                  setState(() {
                    if (GameData.track == 1) {
                      GameData._character = Catalog.shooter;
                      SampleApp.option = "shooter";
                      SampleApp.title="Shooter Games";
                    }
                    if (GameData.track == 2) {
                      GameData._character = Catalog.mmofps;
                      SampleApp.option = "mmofps";
                      SampleApp.title="MMOFPS Games";
                    }
                    if (GameData.track == 3) {
                      GameData._character = Catalog.pvp;
                      SampleApp.option = "pvp";
                      SampleApp.title="PVP Games";
                    }
                    if (GameData.track == 4) {
                      GameData._character = Catalog.mmorpg;
                      SampleApp.option = "mmorpg";
                      SampleApp.title="MMORPG Games";
                    }
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SampleApp()));
                },
                color: Colors.indigoAccent,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(7.0),
                splashColor: Colors.blue,
                child: Text(
                  'Apply',
                  style: TextStyle(fontSize: 19.0),
                ),
              ),
            ],
          ),
        ));
  }
}