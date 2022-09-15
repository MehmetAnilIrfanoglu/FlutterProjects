import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interface2_app/SecondScreen.dart';
import 'Food.dart';
import 'package:http/http.dart' as http;




class SearchAPI extends StatefulWidget {
  static String foods;


  @override
  _SearchAPIState createState() => _SearchAPIState();
}

class _SearchAPIState extends State<SearchAPI> {

  @override
  void initState() {
    super.initState();
  }

  Future<List<Results>> getData() async {
    List<Results> list;
    String link;

    link =
    "https://api.spoonacular.com/recipes/complexSearch?query=${SearchAPI.foods}&number=10&apiKey=58859c01957e44ada5add594efbd2bb6&maxCalories=20000";
    //number=10 is the upperbound
    var res = await http
        .get(Uri.encodeFull(link));

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["results"] as List;
      print(rest);
      list = rest.map<Results>((json) => Results.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    print(list);
    return list;
  }

  Widget listViewWidget(List<Results> results) {

    return Container(
      child: ListView.builder(
          itemCount: results.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            Nutrition a = results[position].nutrition;
            List b = a.nutrients;
            double amount = b[0].amount; // Calories


            return Card(
              child: Container(
                height: 120.0,
                width: 120.0,
                child: Center(
                  child: ListTile(
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Calories: $amount',
                      ),
                    ),
                    title: Text(
                      '${results[position].title}',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _onTapItem(context, results[position]),
                  ),

                ),

              ),

            );
          }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(SearchAPI.foods),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
void _onTapItem(BuildContext context, Results results) {


  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => SecondScreen()));
}