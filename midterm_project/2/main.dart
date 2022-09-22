import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(

  ParseJSON(),

);
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
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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