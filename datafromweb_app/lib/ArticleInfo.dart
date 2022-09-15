import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class ArticleInfo extends StatelessWidget {
  String head;
  String body;
  static String link;
  ArticleInfo(this.head,this.body,link);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(head),


      ),

      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/diet.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height)/12,
                  width: (MediaQuery.of(context).size.width) ,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(child: Text(head, style: TextStyle(fontSize: 25))),
                ),
                Container(
                  height: (MediaQuery.of(context).size.height)/2,
                  width: (MediaQuery.of(context).size.width) ,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(body,softWrap: true, style: TextStyle(fontSize: 16)),
                  ),
                ),

                InkWell(
                    child: new Container(
                      color: Colors.indigoAccent,
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                          'Link'
                      ),
                    ),
                    onTap: () => launch(ArticleInfo.link)
                ),

              ],
            ),
          ),
        ),
      ),

    );


  }




}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(

        body: new Center(
          child: new InkWell(
              child: new Text('Open Browser'),
              onTap: () => launch(ArticleInfo.link)
          ),
        ),
      ),
    );
  }
}