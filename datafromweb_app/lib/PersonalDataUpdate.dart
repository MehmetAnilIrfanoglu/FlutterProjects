import 'homepage.dart';
import 'package:flutter/material.dart';


enum SingingCharacter { low, medium ,high}

class PersonalDataUpdate extends StatefulWidget {
  static bool low=true;
  static bool medium=false;
  static bool high=false;

  static String name;
  static String gender;
  static int age;
  static double weight;
  static double height;

  static double dailyCalorieNeeds = gender.endsWith('emale')?
  655+ (9.6*weight)+ (1.8*height) - (4.7*age)
      :
  66+ (13.7*weight)+(5*height)-(6.8*age);

  static double calorieNeedsWithActivity = low
      ? dailyCalorieNeeds*1.3
      : medium
      ? dailyCalorieNeeds*1.65
      : dailyCalorieNeeds*2;


  @override
  _PersonalDataUpdateState createState() => _PersonalDataUpdateState();
}

class _PersonalDataUpdateState extends State<PersonalDataUpdate> {
  SingingCharacter _character = SingingCharacter.low;
  TextEditingController textName = new TextEditingController();
  TextEditingController textAge = new TextEditingController();
  TextEditingController textWeight = new TextEditingController();
  TextEditingController textHeight = new TextEditingController();

  bool male=false;
  bool female=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Personal Information'),
          backgroundColor: Colors.blue,
        ),
        body:
        Center(
          child: Container(
            width: (MediaQuery.of(context).size.width)/1.3,
            child: ListView(

              padding: const EdgeInsets.all(8),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    decoratedBox(context, 'What is your name'),
                    space(context, 30),
                    TextField(
                      controller: textName,
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'name'),
                    ),
                    space(context, 30),
                    decoratedBox(context, 'What is your gender?'),

                    space(context, 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buttonMale(context),
                        buttonFemale(context),
                      ],
                    ),
                    space(context, 30),
                    decoratedBox(context, 'What is your age'),
                    space(context, 30),
                    TextField(
                      controller: textAge,
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Age'),
                    ),
                    space(context, 30),
                    decoratedBox(context, 'What is your weight'),
                    space(context, 30),
                    TextField(
                      controller: textWeight,
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Weight (kg)'),
                    ),
                    space(context, 30),

                    decoratedBox(context, 'What is your height'),
                    space(context, 30),
                    TextField(

                      controller: textHeight,
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Height (cm)'),
                    ),
                    space(context, 30),


                    space(context, 30),
                    decoratedBox(context, 'how active are you'),
                    space(context, 30),
                    Column(
                      children: <Widget>[
                        RadioListTile<SingingCharacter>(
                          title: const Text('Low performance'),
                          value: SingingCharacter.low,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                              PersonalDataUpdate.low = true;
                              PersonalDataUpdate.medium = false;
                              PersonalDataUpdate.high = false;

                            });
                          },
                        ),
                        RadioListTile<SingingCharacter>(
                          title: const Text('Medium performance'),
                          value: SingingCharacter.medium,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                              PersonalDataUpdate.low = false;
                              PersonalDataUpdate.medium = true;
                              PersonalDataUpdate.high = false;
                            });
                          },
                        ),
                        RadioListTile<SingingCharacter>(
                          title: const Text('high performance'),
                          value: SingingCharacter.high,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                              PersonalDataUpdate.low = false;
                              PersonalDataUpdate.medium = false;
                              PersonalDataUpdate.high = true;
                            });
                          },
                        ),
                      ],
                    ),
                    space(context, 30),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          PersonalDataUpdate.name =textName.text;
                          PersonalDataUpdate.age = int.parse(textAge.text);
                          PersonalDataUpdate.weight = double.parse(textWeight.text);
                          PersonalDataUpdate.height = double.parse(textHeight.text);
                          PersonalDataUpdate.dailyCalorieNeeds = PersonalDataUpdate.gender.endsWith('emale')?
                          655+ (9.6*PersonalDataUpdate.weight)+ (1.8*PersonalDataUpdate.height) - (4.7*PersonalDataUpdate.age)
                              :
                          66+ (13.7*PersonalDataUpdate.weight)+(5*PersonalDataUpdate.height)-(6.8*PersonalDataUpdate.age);
                          PersonalDataUpdate.calorieNeedsWithActivity = PersonalDataUpdate.low
                              ? PersonalDataUpdate.dailyCalorieNeeds*1.3
                              : PersonalDataUpdate.medium
                              ? PersonalDataUpdate.dailyCalorieNeeds*1.65
                              : PersonalDataUpdate.dailyCalorieNeeds*2;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
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
                )
              ],
            ),
          ),
        )

    );
  }

  buttonMale(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          male = true;
          female=false;
          PersonalDataUpdate.gender='male';
        });
      },
      child: Container(
        child: new Container(
          height: 50,
          width: 100,
          decoration: BoxDecoration(
            color: male ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Male'),
          ),
        ),
      ),
    );
  }

  buttonFemale(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          female=true;
          male=false;
          PersonalDataUpdate.gender='female';
        });

      },
      child: Container(
        child: new Container(
          height: 50,
          width: 100,
          decoration: BoxDecoration(
            color: female ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Female'),
          ),
        ),
      ),
    );
  }

  decoratedBox(BuildContext context, String text) {
    return Container(
      height: 70,

      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Center(child: Text(text, style: TextStyle(fontSize: 20))),
    );
  }

  space(BuildContext context, double space) {
    return Container(
      height: space,
    );
  }
}
