import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/courses/listcourses.dart';
import 'package:globtorch/userScreens/discussions.dart';
import 'package:globtorch/userScreens/library.dart';
import 'package:globtorch/userScreens/reports.dart';
import 'package:globtorch/userScreens/resources.dart';
import 'package:globtorch/userScreens/teachers.dart';
import 'package:globtorch/userScreens/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() =>
      _HomePageState(email: email, name: name, surname: surname);

  final String name;
  final String surname;
  final String email;
  HomePage({this.name, this.surname, this.email});
}

class _HomePageState extends State<HomePage> {
  final String name;
  final String surname;
  final String email;
  int _page = 0;
  _HomePageState({this.name, this.surname, this.email});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
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
                  onPressed: () {
                    // Navigator.of(context).push( CupertinoPageRoute(
                    //     builder: (BuildContext context) =>  Notification()));
                  }),
              CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.red,
                child: Text(
                  "0",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              )
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
              height: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
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
                    onTap: () {},
                    child: Container(
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
                  onTap: () {},
                  child: Container(
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
                            "Reports",
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
                  onTap: () {},
                  child: Container(
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
            //third Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
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
                  onTap: () {},
                  child: Container(
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
                  WidgetsFlutterBinding.ensureInitialized();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var emaill = prefs.getString('email');
                  var namee = prefs.getString('name');
                  var surnamee = prefs.getString('surname');
                  Navigator.of(context).push(CupertinoPageRoute(
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
                onTap: () async {
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
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.assessment,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("My Teachers"),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => MyTeachers()));
                },
              ),
              /*  ListTile(
                leading:  CircleAvatar(
                  child:  Icon(
                    Icons.timer,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title:  Text("Assignments"),
                onTap: () {
                  Navigator.of(context).push( CupertinoPageRoute(
                      builder: (BuildContext context) =>  Assignments()));
                },
              ),*/
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.group_work,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Discussions"),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => Discussions()));
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
                title: Text("Report"),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => Reports()));
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
                onTap: () {},
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
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => Library()));
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text("Invite and Earn"),
                onTap: () {},
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ExtResources()));
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
                onTap: () {},
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
                onTap: () {},
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
