import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/loginpage.dart';
import 'package:globtorch/userScreens/signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isDeviceConnected = false;

  @override
  void initState() {
    super.initState();
    getConnect(); // calls getconnect method to check which type if connection it
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: landingBody(),
      ),
    );
  }

  landingBody() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            landingHeader(),
            landingFields(),
            Container(
              height: 10,
            ),
            whyRegisgter(),
            spaceMethod(),
          ],
        ),
      );

  landingHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Image(
              image: AssetImage('assets/images/globt.jpg'),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Welcome To",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey.shade600,
                fontSize: 25),
          ),
          Text(
            "Globtorch Mobile",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey.shade600,
                fontSize: 35),
          ),
          TypewriterAnimatedTextKit(
              totalRepeatCount: 4,
              repeatForever: true, //this will ignore [totalRepeatCount]
              pause: Duration(milliseconds: 1000),
              text: ["Learn Anywhere!", "On your Time!", "Register Today!!!"],
              textStyle: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
              displayFullTextOnTap: true,
              stopPauseOnTap: true),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      );

  landingFields() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: Text(
                "For the first time at Globortch",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
              width: double.infinity,
              child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  color: Colors.white,
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    "SignUp",
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.teal,
                        fontWeight: FontWeight.w400),
                  ),
                  borderSide: BorderSide(
                    color: Colors.teal, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 3.0, //width of the border
                  ),
                  onPressed: () async {
                    if (isDeviceConnected) {
                      http.Response response = await http.get(
                          "https://globtorch.com/api/courses",
                          headers: {"Accept": "application/json"});
                      var json = jsonDecode(response.body);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage(listc: json)));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("No internet connection"),
                            content: Text("Please turn on wifi or mobile data"),
                            actions: <Widget>[
                              FlatButton(
                                child: new Text("OK"),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomePage()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              width: double.infinity,
              child: Text(
                "To perfom day to day operations",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 14.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
              width: double.infinity,
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Colors.white,
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400),
                ),
                borderSide: BorderSide(
                  color: Colors.blue, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 3.0, //width of the border
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                ),
              ),
            ),
          ],
        ),
      );
  spaceMethod() => Container(
        height: 20.0,
      );
  whyRegisgter() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Why Register at Globtorch!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              width: double.infinity,
              child: Text(
                "Zimbabwe’s leading online education specialist offering courses for all levels of learning, from primary to tertiary education",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              width: double.infinity,
              child: Text(
                "Affordable – low cost education where you get more for less; pay for all your courses at once and save big",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              width: double.infinity,
              child: Text(
                "Flexible – with 24/7 course access and support you can learn at your own pace, on your own time",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              width: double.infinity,
              child: Text(
                "Reputable – GLOBTORCH is registered with the Ministry of Primary and Secondary Education as well as tertiary education and exam boards including ACCA, IAC, etc. so we are bound by strict standards of excellence",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              width: double.infinity,
              child: Text(
                "Dynamic – adaptive course content ensures that the education you receive is always relevant",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
}
