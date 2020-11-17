import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateComment extends StatefulWidget {
  const CreateComment({Key key, this.discussionId}) : super(key: key);
  @override
  _CreateCommentState createState() =>
      _CreateCommentState(discIdd: discussionId);
  final int discussionId;
}

class _CreateCommentState extends State<CreateComment> {
  final int discIdd;
  final _formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();

  _CreateCommentState({this.discIdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comment a discussion")),
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
                        "Comment",
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You cannot send an empty comment';
                      }
                      return null;
                    },
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLength: 2000,
                    controller: commentController,
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
                    String comment = commentController.text;
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');
                    final url =
                        "https://globtorch.com/api/discussions/$discIdd/comment?api_token=$token";
                    http.Response response = await http.post(url,
                        headers: {"Accept": "application/json"},
                        body: {'comment': comment});
                    var json = jsonDecode(response.body);
                    print(json);
                    if (response.statusCode == 200) {
                      _formKey.currentState.reset();
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(
                              '${json['message']} \n your comment will be updated shortly',
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
                              "Failed to create a comment",
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
