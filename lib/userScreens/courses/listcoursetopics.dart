import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart' as prefix0;

import 'package:globtorch/userScreens/courses/topicsview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListTopicsContent extends StatefulWidget {
  @override
  _ListTopicsContentState createState() => _ListTopicsContentState(
        coursetopics: coursetopics,
      );
  final List coursetopics;
  final String title;
  ListTopicsContent({this.coursetopics, this.title});
}

class _ListTopicsContentState extends State<ListTopicsContent> {
  final List coursetopics;
  _ListTopicsContentState({this.coursetopics});
  bool visible = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: new Text("Courses Topics"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: coursetopics == null ? 0 : coursetopics.length,
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
                                "${coursetopics[index]['name']}",
                                style: Style.headerTextStyle,
                              ),
                              leading: new CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(161, 108, 164, 1.0),
                                child: new Icon(
                                  Icons.library_books,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                              subtitle: Container(
                                width: 10.0,
                                child: FlatButton(
                                  onPressed: () async {
                                    setState(() {
                                      visible = true;
                                      isLoading = true;
                                    });

                                    int id = coursetopics[index]['id'];

                                    String stringId = id.toString();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var token = prefs.getString('api_token');

                                    String url =
                                        "https://globtorch.com/api/topics";
                                    String fullUrl =
                                        '$url/$stringId?api_token=$token';

                                    http.Response response = await http.get(
                                      fullUrl,
                                      headers: {"Accept": "application/json"},
                                    );
                                    var jsonConvert = jsonDecode(response.body);
                                    Map<String, dynamic> topicncontent =
                                        jsonConvert;
                                    if (response.statusCode == 200 ||
                                        response.statusCode == 201) {
                                      setState(() {
                                        visible = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => jsonConvert !=
                                                      null
                                                  ? TopicViw(
                                                      contentname:
                                                          topicncontent)
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator())));
                                    } else if (response.statusCode == 401 ||
                                        response.statusCode == 403) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: new Text(
                                              "$topicncontent",
                                              style: TextStyle(
                                                  color: prefix0.Colors.red),
                                            ),
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
                                  child: const Text('View Content'),
                                  color: Color.fromRGBO(161, 108, 164, 1.0),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  textColor: Colors.white,
                                ),
                              ),
                              dense: true,
                              trailing: Column(
                                children: <Widget>[
                                  Icon(Icons.assignment_ind),
                                  Expanded(
                                    child: FlatButton(
                                        onPressed: () {},
                                        child: Text("Test"),
                                        color: Colors.red,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0))),
                                  ),
                                ],
                              ),
                              isThreeLine: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future getTopicContent() async {}
}
