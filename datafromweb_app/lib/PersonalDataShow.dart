import 'package:flutter/material.dart';
import 'PersonalDataUpdate.dart';

class PersonalDataShow extends StatefulWidget {
  @override
  _PersonalDataShowState createState() => _PersonalDataShowState();
}

class _PersonalDataShowState extends State<PersonalDataShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
      ),
      body: Center(
        child: Container(
          height: (MediaQuery.of(context).size.height),
          width: (MediaQuery.of(context).size.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Column(

                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text('Name:', style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text('Gender:', style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text('Age:', style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text('Height:', style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text('Weight:', style: TextStyle(fontSize: 20))),
                      ),
                    ],
                  ),
                  Column(

                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text(PersonalDataUpdate.name, style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text(PersonalDataUpdate.gender, style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text(PersonalDataUpdate.age.toString(), style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text(PersonalDataUpdate.height.toString(), style: TextStyle(fontSize: 20))),
                      ),
                      Container(
                        height: (MediaQuery.of(context).size.height)/7,
                        width: (MediaQuery.of(context).size.width)/2.3,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(child: Text(PersonalDataUpdate.weight.toString(), style: TextStyle(fontSize: 20))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}
