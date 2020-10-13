import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/assignments.dart';
import 'package:globtorch/userScreens/courses/listcoursechapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListSubjects extends StatelessWidget {
  final List coursesubjects;
  final String coursename;
  ListSubjects({this.coursesubjects, this.coursename});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        flexibleSpace: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(coursename,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
                  SizedBox(height: 10),
                  Text("Course Subjects",
                      style: TextStyle(color: Color(0xff59595a), fontSize: 15)),
                ])),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: coursesubjects == null ? 0 : coursesubjects.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Card(
                          child: ListTile(
                            title: Text(
                              "${coursesubjects[index]['name']}",
                              style: Style.headerTextStyle,
                            ),
                            subtitle: Container(
                                padding:
                                    new EdgeInsets.symmetric(horizontal: 50.0),
                                child: FlatButton(
                                  onPressed: () {
                                    var subjectname =
                                        coursesubjects[index]['name'];
                                    List coursechap =
                                        coursesubjects[index]['chapters'];

                                    Navigator.of(context).push(
                                        new CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                new ListChapters(
                                                    coursechapters: coursechap,
                                                    subname: subjectname)));
                                  },
                                  child: const Text('View '),
                                  color: Colors.green,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  textColor: Colors.white,
                                )),
                            dense: true,
                            trailing: Column(
                              children: <Widget>[
                                Icon(Icons.assignment_ind),
                                Expanded(
                                  child: FlatButton(
                                      onPressed: () async {
                                        int subId = coursesubjects[index]['id'];
                                        String subjectIdString =
                                            subId.toString();
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var token =
                                            prefs.getString('api_token');
                                        final signUrl =
                                            "https://globtorch.com/api/subjects/$subjectIdString/assignments?api_token=$token";
                                        http.Response response = await http
                                            .get(signUrl, headers: {
                                          "Accept": "application/json"
                                        });
                                        var json = jsonDecode(response.body);

                                        List listassignments =
                                            json["assignments"];
                                        var subjectname =
                                            coursesubjects[index]['name'];
                                        Navigator.push(
                                            (context),
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    Assignments(
                                                        listasignmnts:
                                                            listassignments,
                                                        subname: subjectname)));
                                      },
                                      child: Text("Assignment"),
                                      color: Colors.green,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0))),
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
            );
          }),
    );
  }
}
