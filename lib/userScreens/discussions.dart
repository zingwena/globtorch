import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:globtorch/userScreens/creatediscussion.dart';
import 'package:globtorch/userScreens/discussiondetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Discussions extends StatefulWidget {
  const Discussions({Key key, this.subname, this.discussionlist, this.idsub})
      : super(key: key);

  @override
  _DiscussionsState createState() => _DiscussionsState(
      subjctnamedis: subname, listdiscussion: discussionlist, subId: idsub);
  final String subname;
  final List discussionlist;
  final int idsub;
}

class _DiscussionsState extends State<Discussions> {
  final String subjctnamedis;
  final List listdiscussion;
  final int subId;
  _DiscussionsState({this.subjctnamedis, this.listdiscussion, this.subId});

  // flutter local notification setup
  void showNotification(v, flp) async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flp.show(0, 'Virtual intelligent solution', '$v', platform,
        payload: 'VIS \n $v');
  }

  Future<void> callbackDispatcher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('flp');
    showNotification(listdiscussion, email);
  }

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
                          child: Text(subjctnamedis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
                  SizedBox(height: 10),
                  Text("Discussions",
                      style: TextStyle(color: Color(0xff59595a), fontSize: 15)),
                ])),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: listdiscussion == null ? 0 : listdiscussion.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      child: Card(
                        child: ListTile(
                          title: Text(
                            listdiscussion[index]['title'],
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(listdiscussion[index]['body']),
                          onTap: () async {
                            int discussionId = listdiscussion[index]['id'];
                            String discussionIdStrng = discussionId.toString();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var token = prefs.getString('api_token');
                            final discdetailUrl =
                                "https://globtorch.com/api/discussions/$discussionIdStrng?api_token=$token";
                            http.Response response = await http.get(
                                discdetailUrl,
                                headers: {"Accept": "application/json"});
                            var json = jsonDecode(response.body);
                            List comments = json['comments'];
                            Map<String, dynamic> discdetails = json;
                            print(json['id']);
                            int discId = json['id'];
                            Navigator.push(
                                (context),
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DiscussionDetails(
                                            discussionId: discId,
                                            detaildiscussion: discdetails,
                                            commentslist: comments,
                                            sbname: subjctnamedis)));
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('New Discussion'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Navigator.push(
              (context),
              MaterialPageRoute(
                  builder: (BuildContext context) => AddDiscussion(
                      subjectId: subId,
                      sbname: subjctnamedis,
                      disclist: listdiscussion)));
        },
        isExtended: true,
      ),
    );
  }
}
