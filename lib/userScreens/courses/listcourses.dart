import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/animation.dart';
import 'package:globtorch/tools/seperator.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/courses/listcoursesubjects.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ListCourses extends StatefulWidget {
  @override
  _ListCoursesState createState() => _ListCoursesState();
}

class _ListCoursesState extends State<ListCourses> {
  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  List listcourses;
  Future fetchCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('api_token');
    final url = "https://globtorch.com/api/users/courses?api_token=$token";
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
    var json = jsonDecode(response.body);
    print(json);
    setState(() {
      listcourses = json;
    });
    // debugPrint(listcourses.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0xFF398AE5),
          Colors.red,
          Colors.green,
        ])),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeAnimation(
                      2,
                      Text(
                        "My Courses",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: ListView.builder(
                    itemCount: listcourses == null ? 0 : listcourses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(30),
                            side: BorderSide(
                                width: 8, color: Colors.greenAccent[700])),
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/globt.jpg'),
                                ),
                                Text(
                                  "${listcourses[index]["name"]}",
                                  style: Style.titleTextStyle,
                                ),
                                Text(
                                  "${listcourses[index]["price"]}",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "${listcourses[index]["level"]}",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Separator(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: new RaisedButton(
                                          padding: const EdgeInsets.all(8.0),
                                          textColor: Colors.white,
                                          color: Colors.cyanAccent,
                                          onPressed: () async {
                                            int id = listcourses[index]['id'];
                                            String stringId = id.toString();
                                            String url =
                                                "https://globtorch.com/api/courses";
                                            String fullUrl = '$url/$stringId';
                                            String listcoursesname =
                                                listcourses[index]['name'];

                                            http.Response response = await http
                                                .get(fullUrl, headers: {
                                              "Accept": "application/json"
                                            });
                                            var jsonConvert =
                                                jsonDecode(response.body);
                                            List coursesub =
                                                jsonConvert['subjects'];

                                            Navigator.of(context).push(
                                                new CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        new ListSubjects(
                                                          coursesubjects:
                                                              coursesub,
                                                          coursename:
                                                              listcoursesname,
                                                        )));
                                          },
                                          child: new Text(
                                            "View Course",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    Container(
                                      width: 30.0,
                                    ),
                                    /* Expanded(
                                      child: RaisedButton(
                                          padding: const EdgeInsets.all(8.0),
                                          textColor: Colors.white,
                                          color: Colors.red,
                                          onPressed: () {},
                                          child: new Text("Pay Now")),
                                    ),*/
                                  ],
                                ),
                              ],
                            )),
                        color: Colors.blue[500],
                      );
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
