import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(new ParseJSON());

class Photo {

  final String title;


  Photo({ this.title});

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

class Constants{

  static const String Settings = 'Settings';


  static const List<String> choices = <String>[

    Settings,

  ];
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState(){
    super.initState();
    getSharedPreferences();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Isolate Demo"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],

      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),

    );
  }

  void choiceAction(String choice){
    if(choice == Constants.Settings){
      Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalData()));
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

getSharedPreferences() async
{
  SharedPreferences pref = await SharedPreferences.getInstance();
  PersonalData.shooter = pref.getBool("shooter") ?? true;
  PersonalData.mmorpg = pref.getBool("mmorpg") ?? false;
  PersonalData.pvp = pref.getBool("pvp") ?? false;
  PersonalData.mmofps = pref.getBool("mmofps") ?? false;
  PersonalData.counter= pref.getInt("counter")?? 0;
}
setSharedPreferences() async
{
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setBool("shooter", PersonalData.shooter);
  await pref.setBool("mmorpg", PersonalData.mmorpg);
  await pref.setBool("pvp", PersonalData.pvp);
  await pref.setBool("mmofps", PersonalData.mmofps);
  await pref.setInt("counter",PersonalData.counter);

}


Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
  await client.get('https://www.freetogame.com/api/games');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}


enum SingingCharacter { shooter, mmofps ,pvp, mmorpg}

class PersonalData extends StatefulWidget {
  static bool shooter;
  static bool mmofps;
  static bool pvp;
  static bool mmorpg;
  static SingingCharacter _character;
  static int counter;


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
        body:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Column(
                children: <Widget>[
                  Container(child: Text(PersonalData.counter.toString())),
                  RadioListTile<SingingCharacter>(
                    title: const Text('Shooter'),
                    value: SingingCharacter.shooter,
                    groupValue: PersonalData._character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        PersonalData._character = value;
                        PersonalData.shooter = true;
                        PersonalData.mmofps = false;
                        PersonalData.pvp = false;
                        PersonalData.mmorpg=false;
                        PersonalData.counter=1;
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: const Text('Massively Multiplayer Online First-Person Shooter'),
                    value: SingingCharacter.mmofps,
                    groupValue: PersonalData._character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        PersonalData._character = value;
                        PersonalData.shooter = false;
                        PersonalData.mmofps = true;
                        PersonalData.pvp = false;
                        PersonalData.mmorpg=false;
                        PersonalData.counter=2;
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
                        PersonalData.shooter = false;
                        PersonalData.mmofps = false;
                        PersonalData.pvp = true;
                        PersonalData.mmorpg=false;
                        PersonalData.counter=3;
                      });
                    },
                  ),
                  RadioListTile<SingingCharacter>(
                    title: const Text('Massively Multiplayer Online Role-Playing Game'),
                    value: SingingCharacter.mmorpg,
                    groupValue: PersonalData._character,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        PersonalData._character = value;
                        PersonalData.shooter = false;
                        PersonalData.mmofps = false;
                        PersonalData.pvp = false;
                        PersonalData.mmorpg=true;
                        PersonalData.counter=4;

                      });
                    },
                  ),

                ],
              ),

              FlatButton(
                onPressed: () {
                  setSharedPreferences();
                  setState(() {
                    if(PersonalData.shooter){
                      PersonalData._character=SingingCharacter.shooter;
                    }
                    if(PersonalData.mmofps){
                      PersonalData._character=SingingCharacter.mmofps;
                    }
                    if(PersonalData.pvp){
                      PersonalData._character=SingingCharacter.pvp;
                    }
                    if(PersonalData.mmorpg){
                      PersonalData._character=SingingCharacter.mmorpg;
                    }


                  });
                  Navigator.pop(context, MaterialPageRoute(builder: (context) => MyHomePage()));
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
        )

    );
  }






}