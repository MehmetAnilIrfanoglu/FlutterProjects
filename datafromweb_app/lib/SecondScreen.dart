import 'package:flutter/material.dart';
import 'FirstScreen.dart';
import 'homepage.dart';
import 'api/SearchfromApi.dart';
void main(){
  runApp(MaterialApp(
    home:SecondScreen(),
  ));
}

class SecondScreen extends StatefulWidget {

  static List<String> todaysFood=[];
  static double calorie;
  static List<double> dataStore=[]; // To keep track of calorie consumption and show it in the graphs
  static int foodCount=-1;
  static double lastCalorie;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  TextEditingController foodName = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: (){
              //showSearch(context: context, delegate: Search(widget.foodList));
              new Container(
                child: Text("hello"),
              );
            },
            icon: Icon(Icons.search),
          ),

        ],
        centerTitle: true,
        title: Text('Food Search Menu'),

      ),
      body:
      SecondScreen.todaysFood.isEmpty
          ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Add what you eat"),
        Container(
          child:  TextField(
            controller: foodName,
            obscureText: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'For Example Burger'),
          ),

        ),
        FlatButton(

          onPressed: () {
            setState(() {
              SearchAPI.foods=foodName.text;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAPI()));
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
        FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));

          },
          color: Colors.indigoAccent,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(7.0),
          splashColor: Colors.blue,
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 19.0),
          ),
        ),
      ],
      )
          :
      Column(
        children: [
          Expanded(
            child: ListView.builder(

              itemCount: SecondScreen.todaysFood.length,
              itemBuilder: (context, index)=> ListTile(

                leading: Icon(Icons.list),

                title: Text(
                  SecondScreen.todaysFood[index],
                ),
                trailing: Text("Calorie: 50 for now",
                  style: TextStyle(
                      color: Colors.green,fontSize: 15),),

              ),

            ),
          ),
          Container(
            child:  TextField(
              controller: foodName,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Name'),
            ),

          ),
          FlatButton(

            onPressed: () {

              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAPI()));
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
          FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));

            },
            color: Colors.indigoAccent,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(7.0),
            splashColor: Colors.blue,
            child: Text(
              'Submit',
              style: TextStyle(fontSize: 19.0),
            ),
          ),
        ],
      ),






      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.remove),
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          SecondScreen.todaysFood.isEmpty
              ? Text('There is no item to remove')// JUST FOR FILLING SPACE
              : SecondScreen.todaysFood.removeLast();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> SecondScreen()), );
        },
      ),



    );
  }
}