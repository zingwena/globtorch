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
  _ListTopicsContentState createState() =>
      _ListTopicsContentState(coursetopics: coursetopics, tpname: tpcname);
  final List coursetopics;
  final String title;
  final String tpcname;
  ListTopicsContent({this.coursetopics, this.title, this.tpcname});
}

class _ListTopicsContentState extends State<ListTopicsContent> {
  final List coursetopics;
  final String tpname;
  _ListTopicsContentState({this.coursetopics, this.tpname});
  bool visible = false;
  bool isLoading = true;
  String localPath;

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
                          child: Text(tpname,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
                  SizedBox(height: 10),
                  Text("Chapter Topics",
                      style: TextStyle(color: Color(0xff59595a), fontSize: 15)),
                ])),
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
                                      var tpccontentname =
                                          coursetopics[index]['name'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => jsonConvert !=
                                                      null
                                                  ? TopicViw(
                                                      contentname:
                                                          topicncontent,
                                                      contentnaming:
                                                          tpccontentname)
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
                                        onPressed: () async {},
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
}
