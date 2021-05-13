import 'package:flutter/material.dart';
import 'package:Globtorch/tools/style.dart';
import 'package:Globtorch/userScreens/chat/home_screen.dart';
import 'package:Globtorch/userScreens/courses/coursereport.dart';
import 'package:Globtorch/userScreens/courses/listcourses.dart';
import 'package:Globtorch/userScreens/discussion/navigate_to_Discussions.dart';
import 'package:Globtorch/userScreens/feedback.dart';
import 'package:Globtorch/userScreens/library.dart';
import 'package:Globtorch/userScreens/notification.dart';
import 'package:Globtorch/userScreens/resources.dart';
import 'package:Globtorch/userScreens/studentguide.dart';
import 'package:Globtorch/userScreens/teachers.dart';
import 'package:Globtorch/userScreens/welcomePage.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:async';
import 'dart:math';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState(
      email: email, name: name, surname: surname, notificnumber: notific);
  final String name;
  final String surname;
  final String email;
  final String notific;
  HomePage({
    this.name,
    this.surname,
    this.email,
    this.notific,
  });
}

class _HomePageState extends State<HomePage> {
  final String name;
  final String surname;
  final String email;
  int _page = 0;
  String notificnumber;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Random _random = new Random();
  Color _color;

  _HomePageState({this.name, this.surname, this.email, this.notificnumber});
  StreamSubscription<DataConnectionStatus> listener;
  bool isDeviceConnected = false;

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getConnect();
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            "Globtorch",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: false,
        actions: <Widget>[
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    if (isDeviceConnected) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var token = prefs.getString('api_token');
                      final url =
                          "https://www.globtorch.com/api/notifications?api_token=$token";
                      http.Response response = await http
                          .get(url, headers: {"Accept": "application/json"});
                      var json = jsonDecode(response.body);
                      setState(() {
                        int not = json['num_unread_notifications'];
                        notificnumber = not.toString();
                      });
                      print(json);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Notifications(
                              not: json['notifications'],
                              isDeviceConn: isDeviceConnected)));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(
                                "You are no longer connected to the internet"),
                            content: Text("Please turn on wifi or mobile data"),
                            actions: <Widget>[
                              FlatButton(
                                child: new Text("OK"),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  var emaill = prefs.getString('email');
                                  var namee = prefs.getString('name');
                                  var surnamee = prefs.getString('surname');
                                  print(notificnumber);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage(
                                            name: namee,
                                            surname: surnamee,
                                            email: emaill,
                                          )));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }),
              Container(
                  child: notificnumber == null
                      ? Text("")
                      : CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Colors.red,
                          child: Text(
                            notificnumber,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                        ))
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _color = new Color.fromRGBO(_random.nextInt(256),
                            _random.nextInt(256), _random.nextInt(256), 1.0);
                      });
                      if (isDeviceConnected) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var token = prefs.getString('api_token');

                        final url =
                            "https://globtorch.com/api/users/courses?api_token=$token";
                        http.Response response = await http
                            .get(url, headers: {"Accept": "application/json"});
                        var json = jsonDecode(response.body);
                        List courselist = json;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ListCourses(listcse: courselist)));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                  "You are no longer connected to the internet"),
                              content:
                                  Text("Please turn on wifi or mobile data"),
                              actions: <Widget>[
                                FlatButton(
                                  child: new Text("OK"),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var emaill = prefs.getString('email');
                                    var namee = prefs.getString('name');
                                    var surnamee = prefs.getString('surname');
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      color: _color,
                      height: 150,
                      width: 150,
                      child: Card(
                        semanticContainer: true,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.library_books,
                                color: Colors.purple, size: 70.0),
                            Text(
                              "Courses",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _color = new Color.fromRGBO(_random.nextInt(256),
                            _random.nextInt(256), _random.nextInt(256), 1.0);
                      });
                      if (isDeviceConnected) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var token = prefs.getString('api_token');

                        final url =
                            "https://globtorch.com/api/users/courses?api_token=$token";
                        http.Response response = await http
                            .get(url, headers: {"Accept": "application/json"});
                        var json = jsonDecode(response.body);
                        List courselist = json;

                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                CourseDiscussions(listcse: courselist)));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                  "You are no longer connected to the internet"),
                              content:
                                  Text("Please turn on wifi or mobile data"),
                              actions: <Widget>[
                                FlatButton(
                                  child: new Text("OK"),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var emaill = prefs.getString('email');
                                    var namee = prefs.getString('name');
                                    var surnamee = prefs.getString('surname');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HomePage(
                                                  name: namee,
                                                  surname: surnamee,
                                                  email: emaill,
                                                )));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      color: _color,
                      height: 150,
                      width: 150,
                      child: Card(
                        semanticContainer: true,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.assignment,
                              color: Colors.lightBlue,
                              size: 70.0,
                            ),
                            Text(
                              "Discussions",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            //second Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _color = new Color.fromRGBO(_random.nextInt(256),
                          _random.nextInt(256), _random.nextInt(256), 1.0);
                    });
                    if (isDeviceConnected) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var token = prefs.getString('api_token');

                      final url =
                          "https://globtorch.com/api/users/courses?api_token=$token";
                      http.Response response = await http
                          .get(url, headers: {"Accept": "application/json"});
                      var json = jsonDecode(response.body);
                      List courselist = json;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ReportNavigation(listcse: courselist)));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(
                                "You are no longer connected to the internet"),
                            content: Text("Please turn on wifi or mobile data"),
                            actions: <Widget>[
                              FlatButton(
                                child: new Text("OK"),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  var emaill = prefs.getString('email');
                                  var namee = prefs.getString('name');
                                  var surnamee = prefs.getString('surname');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage(
                                            name: namee,
                                            surname: surnamee,
                                            email: emaill,
                                          )));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    color: _color,
                    height: 150,
                    width: 150,
                    child: Card(
                      semanticContainer: true,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.report, color: Colors.green, size: 70.0),
                          Text(
                            "Report",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _color = new Color.fromRGBO(_random.nextInt(256),
                          _random.nextInt(256), _random.nextInt(256), 1.0);
                    });
                    if (isDeviceConnected) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Library()));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                  "You are no longer connected to the internet"),
                              content:
                                  Text("Please turn on wifi or mobile data"),
                              actions: <Widget>[
                                FlatButton(
                                  child: new Text("OK"),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var emaill = prefs.getString('email');
                                    var namee = prefs.getString('name');
                                    var surnamee = prefs.getString('surname');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HomePage(
                                                  name: namee,
                                                  surname: surnamee,
                                                  email: emaill,
                                                )));
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                  child: Container(
                    color: _color,
                    height: 150,
                    width: 150,
                    child: Card(
                      semanticContainer: true,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.library_add,
                              color: Colors.green, size: 70.0),
                          Text(
                            "Library",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            //third Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _color = new Color.fromRGBO(_random.nextInt(256),
                          _random.nextInt(256), _random.nextInt(256), 1.0);
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => StudentGuide()));
                  },
                  child: Container(
                    color: _color,
                    height: 150,
                    width: 150,
                    child: Card(
                      semanticContainer: true,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.recent_actors,
                              color: Colors.red, size: 70.0),
                          Text(
                            "Student Guide",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _color = new Color.fromRGBO(_random.nextInt(256),
                          _random.nextInt(256), _random.nextInt(256), 1.0);
                    });
                    if (isDeviceConnected) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var token = prefs.getString('api_token');

                      final discdetailUrl =
                          "https://globtorch.com/api/chat_room?api_token=$token";
                      http.Response response = await http.get(discdetailUrl,
                          headers: {"Accept": "application/json"});
                      var json = jsonDecode(response.body);
                      var chatroom = json['chatRooms'];
                      var users = json['users'];

                      //print(json);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen(
                                  chtrom: chatroom, chatsusers: users)));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(
                                "You are no longer connected to the internet"),
                            content: Text("Please turn on wifi or mobile data"),
                            actions: <Widget>[
                              FlatButton(
                                child: new Text("OK"),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  var emaill = prefs.getString('email');
                                  var namee = prefs.getString('name');
                                  var surnamee = prefs.getString('surname');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage(
                                            name: namee,
                                            surname: surnamee,
                                            email: emaill,
                                          )));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    color: _color,
                    height: 150,
                    width: 150,
                    child: Card(
                      semanticContainer: true,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.chat, color: Colors.blue[800], size: 70.0),
                          Text(
                            "Chart",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800]),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  '$name $surname',
                  style: Style.titleTextStyle,
                ),
                accountEmail: Text(
                  "$email",
                  style: Style.baseTextStyle,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Home"),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var emaill = prefs.getString('email');
                  var namee = prefs.getString('name');
                  var surnamee = prefs.getString('surname');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(
                            name: namee,
                            surname: surnamee,
                            email: emaill,
                          )));
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.library_books,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("My Courses"),
                hoverColor: Colors.lightBlueAccent,
                onTap: () async {
                  if (isDeviceConnected) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');

                    final url =
                        "https://globtorch.com/api/users/courses?api_token=$token";
                    http.Response response = await http
                        .get(url, headers: {"Accept": "application/json"});
                    var json = jsonDecode(response.body);
                    List courselist = json;

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ListCourses(listcse: courselist)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(
                              "You are no longer connected to the internet"),
                          content: Text("Please turn on wifi or mobile data"),
                          actions: <Widget>[
                            FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              ListTile(
                enabled: true,
                leading: CircleAvatar(
                  child: Icon(
                    Icons.assessment,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("My Teachers"),
                onTap: () async {
                  if (isDeviceConnected) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');

                    final url =
                        "https://globtorch.com/api/teachers?api_token=$token";
                    http.Response response = await http
                        .get(url, headers: {"Accept": "application/json"});
                    var json = jsonDecode(response.body);
                    var listteachers = json['teachers'];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MyTeachers(myteachers: listteachers)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(
                              "You are no longer connected to the internet"),
                          content: Text("Please turn on wifi or mobile data"),
                          actions: <Widget>[
                            FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),

              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.group_work,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Discussions"),
                onTap: () async {
                  if (isDeviceConnected) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');

                    final url =
                        "https://globtorch.com/api/users/courses?api_token=$token";
                    http.Response response = await http
                        .get(url, headers: {"Accept": "application/json"});
                    var json = jsonDecode(response.body);
                    List courselist = json;

                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            CourseDiscussions(listcse: courselist)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(
                              "You are no longer connected to the internet"),
                          content: Text("Please turn on wifi or mobile data"),
                          actions: <Widget>[
                            FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              //  Divider(),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.report,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Student Report"),
                onTap: () async {
                  if (isDeviceConnected) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');

                    final url =
                        "https://globtorch.com/api/users/courses?api_token=$token";
                    http.Response response = await http
                        .get(url, headers: {"Accept": "application/json"});
                    var json = jsonDecode(response.body);
                    List courselist = json;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ReportNavigation(listcse: courselist)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(
                              "You are no longer connected to the internet"),
                          content: Text("Please turn on wifi or mobile data"),
                          actions: <Widget>[
                            FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Feedback"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Feedbacks()));
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.library_books,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Library"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Library()));
                },
              ),

              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.web,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("External Resources"),
                onTap: () {
                  if (isDeviceConnected) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ExtResources()));
                  }
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Chart"),
                onTap: () async {
                  if (isDeviceConnected) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');

                    final discdetailUrl =
                        "https://globtorch.com/api/chat_room?api_token=$token";
                    http.Response response = await http.get(discdetailUrl,
                        headers: {"Accept": "application/json"});
                    var json = jsonDecode(response.body);
                    var chatroom = json['chatRooms'];
                    var users = json['users'];

                    //print(json);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen(
                                chtrom: chatroom, chatsusers: users)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(
                              "You are no longer connected to the internet"),
                          content: Text("Please turn on wifi or mobile data"),
                          actions: <Widget>[
                            FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Student Guide"),
                onTap: () {
                  // _scaffoldKey.currentState.showSnackBar(
                  //   SnackBar(
                  //     backgroundColor: Colors.white,
                  //     content: Text(
                  //       "The student Guide will be updated soon",
                  //       style: TextStyle(color: Colors.green),
                  //     ),
                  //   ),
                  // );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => StudentGuide()));
                },
              ),
              ListTile(
                trailing: CircleAvatar(
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('api_token');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => WelcomePage()));
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.library_books, size: 30),
          Icon(Icons.group_add, size: 30),
          Icon(Icons.report, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
