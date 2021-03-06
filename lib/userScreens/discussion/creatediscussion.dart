import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddDiscussion extends StatefulWidget {
  const AddDiscussion({Key key, this.subjectId, this.sbname, this.disclist})
      : super(key: key);

  @override
  _AddDiscussionState createState() => _AddDiscussionState(
      subId: subjectId, subjectname: sbname, discusionlist: disclist);
  final int subjectId;
  final String sbname;
  final List disclist;
}

class _AddDiscussionState extends State<AddDiscussion> {
  final int subId;
  final List discusionlist;
  final String subjectname;
  TextEditingController titleController = TextEditingController();
  TextEditingController discussionController = TextEditingController();

  _AddDiscussionState({this.discusionlist, this.subjectname, this.subId});
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  @override
  void dispose() {
    discussionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Create a Discussion"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Title",
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                    controller: titleController,
                    decoration: InputDecoration.collapsed(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        hintText: null),
                  ),
                ],
              ),
            ),

            // Third Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Discussion",
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Discussion cannot be empty';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                    maxLines: 4,
                    // keyboardType: TextInputType.multiline,
                    maxLength: 2000,
                    controller: discussionController,
                    decoration: InputDecoration.collapsed(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        hintText: null),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 15.0, left: 200.0, right: 10.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 25.0,
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String title = titleController.text;
                        String discussion = discussionController.text;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var token = prefs.getString('api_token');
                        if (isDeviceConnected) {
                          final url =
                              "https://globtorch.com/api/subjects/$subId/discussions?api_token=$token";
                          http.Response response = await http.post(url,
                              headers: {"Accept": "application/json"},
                              body: {'title': title, 'body': discussion});
                          var json = jsonDecode(response.body);
                          // print(json);
                          if (response.statusCode == 200) {
                            _formKey.currentState.reset();
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text(
                                    "${json['message']} \n Your discusion will be updated shortly",
                                    style: TextStyle(color: Colors.green),
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text(
                                    "Failed to create a discussion",
                                    style: TextStyle(color: Colors.red),
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
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text(
                                    "You are no longer connected to the internet"),
                                content:
                                    Text("Please turn on wifi or mobile data"),
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
                      }
                    })
                /* RaisedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    String title = titleController.text;
                    String discussion = discussionController.text;
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');
                    if (isDeviceConnected) {
                      final url =
                          "https://globtorch.com/api/subjects/$subId/discussions?api_token=$token";
                      http.Response response = await http.post(url,
                          headers: {"Accept": "application/json"},
                          body: {'title': title, 'body': discussion});
                      var json = jsonDecode(response.body);
                      // print(json);
                      if (response.statusCode == 200) {
                        _formKey.currentState.reset();
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                "${json['message']} \n Your discusion will be updated shortly",
                                style: TextStyle(color: Colors.green),
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
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                "Failed to create a discussion",
                                style: TextStyle(color: Colors.red),
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
                    
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(
                                "You are no longer connected to the internet"),
                            content: Text("Please turn on wifi or mobile data"),
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
                  }
                },
                textColor: Colors.green,
                label: Icon(Icons.navigate_next),
                icon: Text("Send"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.green)),
              ),*/
                ),
          ],
        ),
      ),
    );
  }
}
