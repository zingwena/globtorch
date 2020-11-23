import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/discussion/discussions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FromCourseDiscussions extends StatefulWidget {
  final List coursesubjects;
  final String coursename;
  FromCourseDiscussions({this.coursesubjects, this.coursename});
  @override
  _FromCourseDiscussionsState createState() => _FromCourseDiscussionsState(
      coursenamee: coursename, coursesubjectss: coursesubjects);
}

class _FromCourseDiscussionsState extends State<FromCourseDiscussions> {
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

  final List coursesubjectss;
  final String coursenamee;

  _FromCourseDiscussionsState({this.coursesubjectss, this.coursenamee});
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
                      Text("Discussions",
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
                                        //print(disclist);
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
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: const Text('Discussions '),
                                    color: Colors.green,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    textColor: Colors.white,
                                  )),

                              // isThreeLine: true,
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
