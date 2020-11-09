import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:globtorch/userScreens/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'userScreens/welcomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";

// flutter local notification setup
HomePage homePage;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher,
      isInDebugMode:
          true); //to true if still in testing lev turn it to false whenever you are launching the app
  await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15), //when should it check the link
      initialDelay:
          Duration(seconds: 5), //duration before showing the notification
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));

  runApp(
    MaterialApp(
      title: 'Globtorch Mobile',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

void showNotification(v, flp) async {
  var android = AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(0, 'Virtual intelligent solution', '$v', platform,
      payload: 'VIS \n $v');
}

Future callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('api_token');
    if (token != null) {
      var response = await http
          .get('https://www.globtorch.com/api/notifications?api_token=$token');
      print("here================");
      print(response);
      var convert = json.decode(response.body);
      if (convert['status'] == 200) {
        showNotification(convert['title'], flp);
      } else {
        print("no messgae");
      }
    } else {
      print("no token");
    }

    return Future.value(true);
  });
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
