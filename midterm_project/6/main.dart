import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new ParseJSON());

class Photo {
  final String title;
  Photo({this.title});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      title: json['title'] as String,
    );
  }
}

class ParseJSON extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class Change {
  static const String Sett = 'Settings';
  static const List<String> selected = <String>[
    Sett,
  ];
}

class MyHomePage extends StatefulWidget {
  @override
  static bool firebase_empty = false;
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Firebase.initializeApp().then((value) {
      checkIfFirebaseEmpty().then((isEmpty) {
        if(!isEmpty){
          MyHomePage.firebase_empty=false;
        }
        if(isEmpty){
          MyHomePage.firebase_empty=true;
        }
      });
    });
    super.initState();
    getSharedPreferences();
  }

  Widget futureBuilderCreator(){
    if(MyHomePage.firebase_empty == true){
      return Container();
    }
    else{
      return FutureBuilder(
        /* GET OBJECTS FROM THE API */
          future: fetchPhotos(http.Client()),
          builder: (BuildContext context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            {

              return Center(child: CircularProgressIndicator());
            }
            else {
              if(snapshot.hasData == false)
              {
                return Center(child: Icon(Icons.error));
              }
              else
              {
                List gameList = snapshot.data;
                int length = gameList.length;
                if(length >= 10)
                  length = 10;
                return ListView.separated(
                  itemCount: length,
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (BuildContext context, int index)
                  {
                    Photo game = gameList[index];
                    AddGameToFire('${game.title}').addGame();

                    return ListTile(
                      title: Text('${game.title}'),
                    );
                  },
                );
              }
            }
          }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        title: new Text("Game Database"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Change.selected.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: MyHomePage.firebase_empty?FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ):
      futureBuilderCreator(),
    );
  }

  void choiceAction(String choice) {
    if (choice == Change.Sett) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PersonalData()));
    }
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: 10,
      separatorBuilder: (BuildContext context, int number) => Divider(
        color: Colors.black,
      ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
                height: 50,
                color: Colors.green,
                child: Center(child: Text(photos[index].title))),
            Divider(
              height: 12,
            )
          ],
        );
      },
    );
  }
}

Future<bool> checkIfFirebaseEmpty() async{

  bool emptyState = await GetGamesFromFire().checkIfEmpty();

  return emptyState;
}

class GetGamesFromFire {

  Future<List<String>> getGames() async {
    CollectionReference games = FirebaseFirestore.instance.collection('games');

    List<String> gameList = List<String>();

    var snapshot = await games.get();

    snapshot.docs.forEach((element) {
      String name = element['name'];

      gameList.add(name);
    });

    return gameList;

  }

  Future<bool> checkIfEmpty() async {
    CollectionReference games = FirebaseFirestore.instance.collection('games');

    var snapshot = await games.get();
    if (snapshot.size > 0) {

      return false;
    }
    else{

      return true;
    }
  }
}
class AddGameToFire {

  final String gameTitle;

  AddGameToFire(this.gameTitle);

  Future<void> addGame(){
    CollectionReference games = FirebaseFirestore.instance.collection('games');
    return games.add({
      'name': gameTitle
    });
  }
}

getSharedPreferences() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  PersonalData.track = pref.getInt("track") ?? 0;
}

setSharedPreferences() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  await pref.setInt("track", PersonalData.track);
}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get('https://www.freetogame.com/api/games');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

enum SingingCharacter { shooter, mmofps, pvp, mmorpg }

class PersonalData extends StatefulWidget {
  static int track;

  static SingingCharacter _character;

  @override
  _PersonalDataState createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Personal Information'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: <Widget>[
                  Container(
                    child: Text(PersonalData.track.toString()),
                  ),
                  RadioListTile<SingingCharacter>(
                    title: const Text('Shooter'),
                    value: SingingCharacter.shooter,
                    groupValue: PersonalData._character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        PersonalData._character = value;

                        PersonalData.track = 1;
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: const Text(
                        'Massively Multiplayer Online First-Person Shooter'),
                    value: SingingCharacter.mmofps,
                    groupValue: PersonalData._character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        PersonalData._character = value;

                        PersonalData.track = 2;
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: const Text('Player versus Player'),
                    value: SingingCharacter.pvp,
                    groupValue: PersonalData._character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        PersonalData._character = value;

                        PersonalData.track = 3;
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: const Text(
                        'Massively Multiplayer Online Role-Playing Game'),
                    value: SingingCharacter.mmorpg,
                    groupValue: PersonalData._character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        PersonalData._character = value;

                        PersonalData.track = 4;
                      });
                    },
                  ),

                ],
              ),
              FlatButton(
                onPressed: () {
                  setSharedPreferences();
                  setState(() {
                    if (PersonalData.track == 1) {
                      PersonalData._character = SingingCharacter.shooter;
                      print('Category Shooter has been choosed');
                    }
                    if (PersonalData.track == 2) {
                      PersonalData._character = SingingCharacter.mmofps;
                      print('Category MMOFPS has been choosed');
                    }
                    if (PersonalData.track == 3) {
                      PersonalData._character = SingingCharacter.pvp;
                      print('Category PVP has been choosed');
                    }
                    if (PersonalData.track == 4) {
                      PersonalData._character = SingingCharacter.mmorpg;
                      print('Category MMORPG has been choosed');
                    }
                  });
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                color: Colors.indigoAccent,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(7.0),
                splashColor: Colors.blue,
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 19.0),
                ),
              ),
            ],
          ),
        ));
  }
}