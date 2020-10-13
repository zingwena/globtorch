import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/courses/listcoursetopics.dart';

class ListChapters extends StatelessWidget {
  final List coursechapters;
  final String subname;
  ListChapters({this.coursechapters, this.subname});

  @override
  Widget build(BuildContext context) {
    //print(coursechapters);
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
                          child: Text(subname,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
                  SizedBox(height: 10),
                  Text("Subject Chapters",
                      style: TextStyle(color: Color(0xff59595a), fontSize: 15)),
                ])),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: coursechapters == null ? 0 : coursechapters.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: <Widget>[
                  // Text(
                  //   "$coursename",
                  //   style: Style.titleTextStyle,
                  // ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Card(
                          child: ListTile(
                            title: Text(
                              "${coursechapters[index]['name']}",
                              style: Style.headerTextStyle,
                            ),
                            subtitle: Container(
                                padding:
                                    new EdgeInsets.symmetric(horizontal: 50.0),
                                child: FlatButton(
                                  onPressed: () {
                                    var topicname =
                                        coursechapters[index]['name'];
                                    List coursetopics =
                                        coursechapters[index]['topics'];
                                    Navigator.of(context).push(
                                        new CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                new ListTopicsContent(
                                                    coursetopics: coursetopics,
                                                    tpcname: topicname)));
                                  },
                                  child: const Text(
                                    'View Topics',
                                  ),
                                  color: Color.fromRGBO(161, 108, 164, 1.0),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  textColor: Colors.white,
                                )),
                            dense: true,
                            onTap: () {
                              List coursetopics =
                                  coursechapters[index]['topics'];
                              Navigator.of(context).push(new CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      new ListTopicsContent(
                                        coursetopics: coursetopics,
                                      )));
                            },
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
