import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Feedbacks extends StatefulWidget {
  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  var wifiIP;
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

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Text(
              "Please leave us your feedback. We will use it to improve our system. Thank you!",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Feedback",
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLength: 2000,
                    controller: feedbackController,
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
                      String commentTeacher = feedbackController.text;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var token = prefs.getString('api_token');
                      if (isDeviceConnected) {
                        final url =
                            "https://globtorch.com/api/feedbacks?api_token=$token";
                        http.Response response = await http.post(url,
                            headers: {"Accept": "application/json"},
                            body: {'data': commentTeacher});
                        var json = jsonDecode(response.body);
                        print(json);
                        feedbackController.clear();
                        if (response.statusCode == 200) {
                          _formKey.currentState.reset();
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                json['status'],
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text(
                                  "Failed to send a feedback",
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Feedbacks()));
                                    // Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                )
                /* RaisedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    String commentTeacher = feedbackController.text;
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');
                    if (isDeviceConnected) {
                      final url =
                          "https://globtorch.com/api/feedbacks?api_token=$token";
                      http.Response response = await http.post(url,
                          headers: {"Accept": "application/json"},
                          body: {'data': commentTeacher});
                      var json = jsonDecode(response.body);
                      print(json);
                      feedbackController.clear();
                      if (response.statusCode == 200) {
                        _formKey.currentState.reset();
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.white,
                            content: Text(
                              json['status'],
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                "Failed to send a feedback",
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Feedbacks()));
                                  // Navigator.of(context).pop();
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
