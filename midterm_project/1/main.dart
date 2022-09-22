import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> gameList = [

    "Blade and Soul", "Armored Warfare", "Trove", "World of Warships", "ArcheAge",
    "Dauntless","World of Tanks", "Warframe", "Cuisine Royale", "Crossout",
  ];
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Games',

          ),
        ),
        body: ListView.separated(
            itemCount: gameList.length,
            separatorBuilder: (BuildContext context, int number) => Divider(
              color: Colors.black,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.all(10),
                color: Colors.green,
                height: 50.0,
                child: Center(
                  child: Text(
                    '${gameList[index]}',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}