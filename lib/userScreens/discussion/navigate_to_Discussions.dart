import 'package:Globtorch/tools/animation.dart';
import 'package:Globtorch/tools/seperator.dart';
import 'package:Globtorch/tools/style.dart';
import 'package:Globtorch/userScreens/discussion/fromcoursediscussions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseDiscussions extends StatefulWidget {
  final List listcse;

  const CourseDiscussions({Key key, this.listcse}) : super(key: key);
  @override
  _CourseDiscussionsState createState() =>
      _CourseDiscussionsState(listcourses: listcse);
}

class _CourseDiscussionsState extends State<CourseDiscussions> {
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

  final List listcourses;

  _CourseDiscussionsState({this.listcourses});
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeAnimation(
                  1,
                  Text(
                    "Discussions",
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
                  if (listcourses == null) {
                    return Container(
                      child: Column(
                        children: [
                          Text("No Courses to display"),
                        ],
                      ),
                    );
                  } else
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
                                "${listcourses[index]["level"]}",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Separator(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      onPressed: () async {
                                        if (isDeviceConnected) {
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
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          FromCourseDiscussions(
                                                            coursesubjects:
                                                                coursesub,
                                                            coursename:
                                                                listcoursesname,
                                                          )));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "You are no longer connected to the internet"),
                                                content: Text(
                                                    "Please turn on wifi or mobile data"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("OK"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Text(
                                        "View Discussions",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                    width: 30.0,
                                  ),
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
