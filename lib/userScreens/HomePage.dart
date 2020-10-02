import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/assignments.dart';
import 'package:globtorch/userScreens/courses/listcourses.dart';
import 'package:globtorch/userScreens/discussions.dart';
import 'package:globtorch/userScreens/library.dart';
import 'package:globtorch/userScreens/reports.dart';
import 'package:globtorch/userScreens/teachers.dart';
import 'package:globtorch/userScreens/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          child: new Text(
            "Globtorch",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: false,
        actions: <Widget>[
          new Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    // Navigator.of(context).push(new CupertinoPageRoute(
                    //     builder: (BuildContext context) => new Notification()));
                  }),
              new CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.red,
                child: new Text(
                  "0",
                  style: new TextStyle(color: Colors.white, fontSize: 12.0),
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
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new GestureDetector(
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
                            new Icon(Icons.library_books,
                                color: Colors.purple, size: 70.0),
                            new Text(
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
                  new GestureDetector(
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
                            new Icon(
                              Icons.assignment,
                              color: Colors.lightBlue,
                              size: 70.0,
                            ),
                            new Text(
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
            new SizedBox(
              height: 20.0,
            ),
            //second Row
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new GestureDetector(
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
                          new Icon(Icons.report,
                              color: Colors.green, size: 70.0),
                          new Text(
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
                new GestureDetector(
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
                          new Icon(Icons.library_add,
                              color: Colors.green, size: 70.0),
                          new Text(
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
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new GestureDetector(
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
                          new Icon(Icons.recent_actors,
                              color: Colors.red, size: 70.0),
                          new Text(
                            "Student Guide",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                new GestureDetector(
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
                          new Icon(Icons.chat,
                              color: Colors.blue[800], size: 70.0),
                          new Text(
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
      drawer: new Drawer(
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: new Text(
                  '$name $surname',
                  style: Style.titleTextStyle,
                ),
                accountEmail: new Text(
                  "$email",
                  style: Style.baseTextStyle,
                ),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Icon(Icons.person),
                ),
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Home"),
                onTap: () async {
                  WidgetsFlutterBinding.ensureInitialized();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var emaill = prefs.getString('email');
                  var namee = prefs.getString('name');
                  var surnamee = prefs.getString('surname');
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new HomePage(
                            name: namee,
                            surname: surnamee,
                            email: emaill,
                          )));
                },
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.library_books,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("My Courses"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new ListCourses()));
                },
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.assessment,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("My Teachers"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new MyTeachers()));
                },
              ),
              /* new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.timer,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Assignments"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new Assignments()));
                },
              ),*/
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.group_work,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Discussions"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new Discussions()));
                },
              ),
              // new Divider(),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.report,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Report"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new Reports()));
                },
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Feedback"),
                onTap: () {},
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.library_books,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Library"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new Library()));
                },
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Invite and Earn"),
                onTap: () {},
              ),

              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("External Resources"),
                onTap: () {},
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Chart"),
                onTap: () {},
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Student Guide"),
                onTap: () {},
              ),
              new ListTile(
                trailing: new CircleAvatar(
                  child: new Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text(
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
