import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
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
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;
  @override
  void initState() {
    super.initState();
    getConnect(); // calls getconnect method to check which type if connection it
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
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
          children: <Widget>[landingHeader(), landingFields(), spaceMethod()],
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
                    if (isInternetOn) {
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
}
