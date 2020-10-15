import 'dart:ui';

import 'package:flutter/material.dart';

class DiscussionDetails extends StatefulWidget {
  const DiscussionDetails(
      {Key key, this.detaildiscussion, this.commentslist, this.sbname})
      : super(key: key);
  @override
  _DiscussionDetailsState createState() => _DiscussionDetailsState(
      discussiondetails: detaildiscussion,
      listcomentss: commentslist,
      subjectname: sbname);
  final Map<String, dynamic> detaildiscussion;
  final List commentslist;
  final String sbname;
}

class _DiscussionDetailsState extends State<DiscussionDetails> {
  final Map<String, dynamic> discussiondetails;
  final List listcomentss;

  final String subjectname;
  _DiscussionDetailsState(
      {this.discussiondetails, this.listcomentss, this.subjectname});

  //
  //  = prefs.getString('api_token');
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
                          child: Text(subjectname,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
                  SizedBox(height: 10),
                  Text("Discussion Details",
                      style: TextStyle(color: Color(0xff59595a), fontSize: 15)),
                ])),
        centerTitle: true,
      ),
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
                                  Icons.person,
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
        ],
      ),
    );
  }
}
