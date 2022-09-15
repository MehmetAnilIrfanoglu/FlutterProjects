import 'package:flutter/material.dart';
import 'PersonalDataUpdate.dart';
import 'homepage.dart';


class Login extends StatefulWidget {
  static bool firstTime = true;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controlName = new TextEditingController();
  TextEditingController controlPasword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height)/30,
              ),
              Container(
                height: (MediaQuery.of(context).size.height)/5,
                width: (MediaQuery.of(context).size.width)/1.2,

                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Center(child: Text('Calorie Check', style: TextStyle(
                  fontSize: 50,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Colors.blue[700],
                ),)),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height)/30,
              ),

              TextField(
                controller: controlName,
                obscureText: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Name'),
              ),
              TextField(
                controller: controlPasword,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
              FlatButton(
                onPressed: () {
                  if (controlName.text == 'admin' &&
                      controlPasword.text == '123') {


                    if (Login.firstTime == true){
                      setState(() {
                        Login.firstTime=false;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDataUpdate()));
                    }
                    else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));

                    }


                  } else {
                    setState(() {


                    });
                  }

                },
                color: Colors.indigoAccent,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(7.0),
                splashColor: Colors.blue,
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 19.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
