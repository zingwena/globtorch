import 'dart:convert';
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
                    keyboardType: TextInputType.multiline,
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
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
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
              padding: EdgeInsets.only(top: 15.0, left: 300.0, right: 10.0),
              child: RaisedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    String title = titleController.text;
                    String discussion = discussionController.text;
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');
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
                              json['message'],
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
                    /*  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text(
                      'Successifully add a discussion!',
                      style: TextStyle(color: Colors.green),
                    )));
                     Navigator.push(
                        (context),
                         MaterialPageRoute(
                             builder: (BuildContext context) => Discussions(
                                subname: subjectname,
                                discussionlist: discusionlist,
                                idsub: subId)));
                                */
                  }
                },
                textColor: Colors.green,
                label: Icon(Icons.navigate_next),
                icon: Text("Send"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
