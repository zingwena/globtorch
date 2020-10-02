import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/courses/listcoursetopics.dart';

class ListChapters extends StatelessWidget {
  final List coursechapters;
  ListChapters({this.coursechapters});

  @override
  Widget build(BuildContext context) {
    //print(coursechapters);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: new Text("Courses Chapters"),
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
                                    List coursetopics =
                                        coursechapters[index]['topics'];
                                    Navigator.of(context).push(
                                        new CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                new ListTopicsContent(
                                                  coursetopics: coursetopics,
                                                )));
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
