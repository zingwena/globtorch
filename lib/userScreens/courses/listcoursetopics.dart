import 'dart:convert';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:globtorch/userScreens/courses/chaptertest.dart';
import 'package:globtorch/userScreens/courses/topicsview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListTopicsContent extends StatefulWidget {
  @override
  _ListTopicsContentState createState() => _ListTopicsContentState(
      coursetopics: coursetopics, tpname: tpcname, chapterId: idChapter);
  final List coursetopics;
  final String title;
  final String tpcname;
  final String idChapter;
  ListTopicsContent(
      {this.coursetopics, this.title, this.tpcname, this.idChapter});
}

class _ListTopicsContentState extends State<ListTopicsContent> {
  final List coursetopics;
  final String tpname;
  final String chapterId;
  _ListTopicsContentState({this.coursetopics, this.tpname, this.chapterId});
  bool visible = false;
  bool isLoading = true;
  String localPath;
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
                              child: Text(tpname,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  )))),
                      SizedBox(height: 10),
                      Text("Chapter Topics",
                          style: TextStyle(
                              color: Color(0xff59595a), fontSize: 15)),
                    ])),
            centerTitle: true,
          )),
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
                              leading: CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(161, 108, 164, 1.0),
                                child: Icon(
                                  Icons.library_books,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                              subtitle: Container(
                                width: 10.0,
                                child: FlatButton(
                                  onPressed: () async {
                                    if (isInternetOn) {
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
                                      var jsonConvert =
                                          jsonDecode(response.body);
                                      Map<String, dynamic> topicncontent =
                                          jsonConvert;
                                      if (response.statusCode == 200 ||
                                          response.statusCode == 201) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        var tpccontentname =
                                            coursetopics[index]['name'];
                                        //print(topicncontent);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => jsonConvert ==
                                                        null
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : TopicViw(
                                                        contentname:
                                                            topicncontent,
                                                        contentnaming:
                                                            tpccontentname)));
                                      } else if (response.statusCode == 401 ||
                                          response.statusCode == 403) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                "$topicncontent",
                                                style: TextStyle(
                                                    color: prefix0.Colors.red),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Failed",
                                                style: TextStyle(
                                                    color: prefix0.Colors.red),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  textColor: Colors.white,
                                ),
                              ),
                              dense: true,
                              trailing: Column(
                                children: <Widget>[
                                  Icon(Icons.assignment_ind),
                                  Expanded(
                                    child: FlatButton(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var token =
                                              prefs.getString('api_token');
                                          String url =
                                              "https://globtorch.com/api/chapters/$chapterId/answers/create?api_token=$token";
                                          http.Response response =
                                              await http.get(
                                            url,
                                            headers: {
                                              "Accept": "application/json"
                                            },
                                          );
                                          var jsonConvert =
                                              jsonDecode(response.body);
                                          List questions =
                                              jsonConvert['chapter']
                                                  ['questions'];
                                          Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          TestChapters(
                                                              testquestions:
                                                                  questions)));
                                        },
                                        child: Text("Test"),
                                        color: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
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
