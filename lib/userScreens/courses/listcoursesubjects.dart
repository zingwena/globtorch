import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/assigment/assignments.dart';
import 'package:globtorch/userScreens/courses/listcoursechapters.dart';
import 'package:globtorch/userScreens/discussion/discussions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListSubjects extends StatefulWidget {
  final List coursesubjects;
  final String coursename;
  ListSubjects({this.coursesubjects, this.coursename});
  @override
  _ListSubjectsState createState() => _ListSubjectsState(
      coursenamee: coursename, coursesubjectss: coursesubjects);
}

class _ListSubjectsState extends State<ListSubjects> {
  final List coursesubjectss;
  final String coursenamee;

  _ListSubjectsState({this.coursesubjectss, this.coursenamee});
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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            backgroundColor: Colors.green[400],
            flexibleSpace: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(coursenamee,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  )))),
                      SizedBox(height: 10),
                      Text("Course Subjects",
                          style: TextStyle(
                              color: Color(0xff59595a), fontSize: 15)),
                    ])),
            centerTitle: true,
          )),
      body: ListView.builder(
          itemCount: coursesubjectss == null ? 0 : coursesubjectss.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        child: Card(
                          child: Container(
                            height: 110,
                            child: ListTile(
                              title: Text(
                                "${coursesubjectss[index]['name']}",
                                style: Style.headerTextStyle,
                              ),
                              subtitle: Container(
                                  width: 10.0,
                                  child: FlatButton(
                                    onPressed: () {
                                      var subjectname =
                                          coursesubjectss[index]['name'];
                                      List coursechap =
                                          coursesubjectss[index]['chapters'];

                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new ListChapters(
                                                      coursechapters:
                                                          coursechap,
                                                      subname: subjectname)));
                                    },
                                    child: const Text('View '),
                                    color: Colors.green,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    textColor: Colors.white,
                                  )),
                              trailing: Container(
                                height: 110,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: FlatButton.icon(
                                        onPressed: () async {
                                          if (isInternetOn) {
                                            int subId =
                                                coursesubjectss[index]['id'];
                                            String subjectIdString =
                                                subId.toString();
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            var token =
                                                prefs.getString('api_token');
                                            final asignUrl =
                                                "https://globtorch.com/api/subjects/$subjectIdString/assignments?api_token=$token";
                                            http.Response response = await http
                                                .get(asignUrl, headers: {
                                              "Accept": "application/json"
                                            });
                                            var json =
                                                jsonDecode(response.body);

                                            List listassignments =
                                                json["assignments"];
                                            var subjectname =
                                                coursesubjectss[index]['name'];
                                            Navigator.push(
                                                (context),
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        Assignments(
                                                            listasignmnts:
                                                                listassignments,
                                                            subname:
                                                                subjectname)));
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: new Text(
                                                    "Failed to create a discussion",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: new Text("OK"),
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
                                        label: Text("Assignments"),
                                        color: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0)),
                                        icon: Icon(Icons.assignment),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    Expanded(
                                        child: FlatButton.icon(
                                      label: Text("Discussions"),
                                      onPressed: () async {
                                        if (isInternetOn) {
                                          int subId =
                                              coursesubjectss[index]['id'];
                                          String subjectIdString =
                                              subId.toString();
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var token =
                                              prefs.getString('api_token');
                                          final disUrl =
                                              "https://globtorch.com/api/subjects/$subjectIdString/discussions?api_token=$token";

                                          http.Response response = await http
                                              .get(disUrl, headers: {
                                            "Accept": "application/json"
                                          });
                                          var json = jsonDecode(response.body);

                                          List disclist = json;

                                          var subjectname =
                                              coursesubjectss[index]['name'];
                                          Navigator.push(
                                              (context),
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Discussions(
                                                              subname:
                                                                  subjectname,
                                                              discussionlist:
                                                                  disclist,
                                                              idsub: subId)));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: new Text(
                                                    "You are no longer connected to the internet"),
                                                content: Text(
                                                    "Please turn on wifi or mobile data"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: new Text("OK"),
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
                                      autofocus: true,
                                      color: Colors.teal,
                                      //color: Color.fromRGBO(161, 108, 164, 1.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0)),
                                      icon: Icon(Icons.people),
                                    ))
                                  ],
                                ),
                              ),
                              isThreeLine: true,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
