import 'package:Globtorch/userScreens/HomePage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'userScreens/welcomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
  );

  runApp(
    MaterialApp(
      title: 'Globtorch Mobile',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          displayColor: Colors.blue,
          fontFamily: "Poppins",
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    _mockCheckForSession().then((status) {
      if (status) {
        _navigateToHome();
      } else {
        return;
      }
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
    return true;
  }

  void _navigateToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var name = prefs.getString('name');
    var token = prefs.getString('api_token');
    var surname = prefs.getString('surname');
    print(token);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => token == null
            ? WelcomePage()
            : HomePage(
                email: email,
                name: name,
                surname: surname,
              )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 80.0,
                          child: Image(
                            image: AssetImage('assets/images/splash.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Learn Anywhere \n On Your Time",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
