import 'package:flutter/material.dart';
import 'FourthScreen.dart';
import 'PersonalDataShow.dart';
import 'PersonalDataUpdate.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  TextEditingController updateWeight = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page',style: TextStyle(fontSize: 20)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Calorie Check',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Update Data'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalDataUpdate()));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalDataShow()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: Container(
        height: (MediaQuery.of(context).size.height),
        width: (MediaQuery.of(context).size.width),
        child: Column(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height) / 2.8,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Calorie Check',style: TextStyle(fontSize: 50)),
                  Icon(
                    Icons.beach_access,
                    color: Colors.blue,
                    size: 45.0,
                  ),
                ],
              ),
            ),
            Expanded(child: ListView(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.height) / 30,
                ),

                SizedBox(
                  height: (MediaQuery.of(context).size.height) / 100,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.height) / 13,
                  child: Center(
                    child: TextField(

                      controller: updateWeight,
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Update Your Weight'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 8, 100, 8),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        PersonalDataUpdate.dailyCalorieNeeds = PersonalDataUpdate.gender.endsWith('emale')?
                        655+ (9.6*PersonalDataUpdate.weight)+ (1.8*PersonalDataUpdate.height) - (4.7*PersonalDataUpdate.age)
                            :
                        66+ (13.7*PersonalDataUpdate.weight)+(5*PersonalDataUpdate.height)-(6.8*PersonalDataUpdate.age);
                        PersonalDataUpdate.calorieNeedsWithActivity = PersonalDataUpdate.low
                            ? PersonalDataUpdate.dailyCalorieNeeds*1.3
                            : PersonalDataUpdate.medium
                            ? PersonalDataUpdate.dailyCalorieNeeds*1.65
                            : PersonalDataUpdate.dailyCalorieNeeds*2;
                        PersonalDataUpdate.weight=double.parse(updateWeight.text);
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(7.0),
                    splashColor: Colors.blue,
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 19.0),
                    ),
                  ),
                ),

                Container(
                  height: (MediaQuery.of(context).size.height) /19,

                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(child: Text('Notifications', style: TextStyle(fontSize: 20))),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.height) / 9,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FourthScreen()));
                    },
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(7.0),
                    splashColor: Colors.blue,
                    child: Text(
                      'Did you know that a suitable diet would be beneficial for your life? '
                          'Click for more details.',
                      style: TextStyle(fontSize: 19.0),
                      softWrap: true,
                    ),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.height) / 9,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FourthScreen()));
                    },
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(7.0),
                    splashColor: Colors.blue,
                    child: Text(
                      'Did you know that a suitable diet would be beneficial for your life? '
                          'Click for more details.',
                      style: TextStyle(fontSize: 19.0),
                      softWrap: true,
                    ),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.height) / 9,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FourthScreen()));
                    },
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(7.0),
                    splashColor: Colors.blue,
                    child: Text(
                      'Did you know that a suitable diet would be beneficial for your life? '
                          'Click for more details.',
                      style: TextStyle(fontSize: 19.0),
                      softWrap: true,
                    ),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.height) / 9,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FourthScreen()));
                    },
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(7.0),
                    splashColor: Colors.blue,
                    child: Text(
                      'Did you know that a suitable diet would be beneficial for your life? '
                          'Click for more details.',
                      style: TextStyle(fontSize: 19.0),
                      softWrap: true,
                    ),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.height) / 9,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FourthScreen()));
                    },
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(7.0),
                    splashColor: Colors.blue,
                    child: Text(
                      'Did you know that a suitable diet would be beneficial for your life? '
                          'Click for more details.',
                      style: TextStyle(fontSize: 19.0),
                      softWrap: true,
                    ),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.height) / 9,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FourthScreen()));
                    },
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(7.0),
                    splashColor: Colors.blue,
                    child: Text(
                      'Did you know that a suitable diet would be beneficial for your life? '
                          'Click for more details.',
                      style: TextStyle(fontSize: 19.0),
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ),



          ],
        ),
      ),
    );
  }
}