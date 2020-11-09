import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/discussion/createcomment.dart';

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

  //
  //  = prefs.getString('api_token');
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
      body: Column(
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
          ListView.builder(
              itemCount: listcomentss == null ? 0 : listcomentss.length,
              itemBuilder: (BuildContext context, int index) {
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
                                  Icons.people,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                              title: Text(
                                  "${listcomentss[index]['user']['name']} ${listcomentss[index]['user']['surname']}"),
                              subtitle: Text(listcomentss[index]['comment']),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              shrinkWrap: true),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 200.0, right: 10.0),
            child: RaisedButton.icon(
              onPressed: () async {
                Navigator.push(
                    (context),
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CreateComment(discussionId: discId)));
              },
              textColor: Colors.green,
              label: Icon(Icons.comment),
              icon: Text("Comment"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green)),
            ),
          ),
        ],
      ),
    );
  }
}
