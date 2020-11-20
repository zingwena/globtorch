import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiscussionDetails extends StatefulWidget {
  const DiscussionDetails(
      {Key key,
      this.detaildiscussion,
      this.commentslist,
      this.sbname,
      this.discussionId})
      : super(key: key);
  @override
  _DiscussionDetailsState createState() => _DiscussionDetailsState(
      discussiondetails: detaildiscussion,
      listcomentss: commentslist,
      subjectname: sbname,
      discId: discussionId);
  final Map<String, dynamic> detaildiscussion;
  final List commentslist;
  final String sbname;
  final int discussionId;
}

class _DiscussionDetailsState extends State<DiscussionDetails> {
  final Map<String, dynamic> discussiondetails;
  final List listcomentss;
  final int discId;
  final String subjectname;
  _DiscussionDetailsState(
      {this.discussiondetails,
      this.listcomentss,
      this.subjectname,
      this.discId});
  TextEditingController _commentController = TextEditingController();
  final GlobalKey<ScaffoldState> scafoldState = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  _buildComment() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: _commentController,
              decoration: InputDecoration.collapsed(
                hintText: 'Comment here!...',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'You cannot send an empty comment';
                }
                return null;
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var token = prefs.getString('api_token');
                  String comment = _commentController.text;
                  String url =
                      'https://globtorch.com/api/discussions/$discId/comment?api_token=$token';
                  final response = await http.post(url,
                      headers: {"Accept": "Application/json"},
                      body: {'comment': comment});
                  var convertedDatatoJson = jsonDecode(response.body);
                  _commentController.clear();
                  if (response.statusCode == 200) {
                    scafoldState.currentState.showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Your comment has been succesifully sent \n it will updated shortly',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    );
                  }

                  print(convertedDatatoJson);
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldState,
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
                              child: Text(subjectname,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  )))),
                      SizedBox(height: 10),
                      Text("Discussion Details",
                          style: TextStyle(
                              color: Color(0xff59595a), fontSize: 15)),
                    ])),
            centerTitle: true,
          )),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Title:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  discussiondetails['title'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              discussiondetails['body'],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Comments:",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listcomentss == null ? 0 : listcomentss.length,
                itemBuilder: (BuildContext context, int index) {
                  if (listcomentss == null) {
                    return Container(
                      child: Column(
                        children: [
                          Text("No Comments to display"),
                        ],
                      ),
                    );
                  } else
                    return Container(
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SingleChildScrollView(
                                child: ListTile(
                                  leading: new CircleAvatar(
                                    child: new Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  title: Text(
                                      "${listcomentss[index]['user']['name']} ${listcomentss[index]['user']['surname']}"),
                                  subtitle:
                                      Text(listcomentss[index]['comment']),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                },
              ),
            ),
            _buildComment()
          ],
        ),
      ),
      // floatingActionButton: _buildComment(),
    );
  }
}
