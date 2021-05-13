import 'package:flutter/material.dart';
import 'package:Globtorch/userScreens/assigment/assignmenttable.dart';
import 'package:Globtorch/userScreens/chat/screens/chat_screen.dart';
import 'package:Globtorch/userScreens/discussion/discfromnotifc.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  const Notifications({this.not, this.isDeviceConn});

  @override
  _NotificationsState createState() =>
      _NotificationsState(notific: not, isConAvailable: isDeviceConn);
  final List not;
  final bool isDeviceConn;
}

class _NotificationsState extends State<Notifications> {
  final List notific;
  final bool isConAvailable;
  _NotificationsState({this.notific, this.isConAvailable});
  bool isDeviceConnected = false;

  /*@override
  void initState() async {
    super.initState();
    getConnect();
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: notific == null ? 0 : notific.length,
        itemBuilder: (context, index) {
          if (notific == null) {
            return Container(
              child: Column(
                children: [
                  Column(
                    children: [
                      Text("No Notifications to display"),
                    ],
                  ),
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
                        child: Card(
                          child: isConAvailable
                              ? ListTile(
                                  title: Text(notific[index]['title']),
                                  onTap: () async {
                                    var navtonotidetails =
                                        notific[index]['link'].toString();
                                    List strings = navtonotidetails.split("/");
                                    var lastindex = strings[strings.length - 1];

                                    for (final listitems in strings) {
                                      if (listitems == "viewassign") {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var token =
                                            prefs.getString('api_token');
                                        final urlAssignment =
                                            "https://globtorch.com/api/assignments/$lastindex?api_token=$token";
                                        http.Response response = await http
                                            .get(urlAssignment, headers: {
                                          "Accept": "application/json"
                                        });
                                        var json = jsonDecode(response.body);
                                        //print(json);
                                        var assgnmentJson = json;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        AssignmentList(
                                                          assignmentdetails:
                                                              assgnmentJson,
                                                        )));
                                      } else if (listitems ==
                                          "view_discussion") {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var token =
                                            prefs.getString('api_token');

                                        final discdetailUrl =
                                            "https://globtorch.com/api/discussions/$lastindex?api_token=$token";
                                        http.Response response = await http
                                            .get(discdetailUrl, headers: {
                                          "Accept": "application/json"
                                        });
                                        var json = jsonDecode(response.body);
                                        List comments = json['comments'];
                                        Map<String, dynamic> discdetails = json;
                                        print(json['id']);
                                        int discId = json['id'];
                                        Navigator.push(
                                            (context),
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        DiscussionFromNotif(
                                                          discussionId: discId,
                                                          detaildiscussion:
                                                              discdetails,
                                                          commentslist:
                                                              comments,
                                                        )));
                                      } else if (listitems == "chat_room") {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var token =
                                            prefs.getString('api_token');
                                        final url =
                                            "https://globtorch.com/api/chat_room/$lastindex?api_token=$token";
                                        http.Response response = await http
                                            .get(url, headers: {
                                          "Accept": "application/json"
                                        });
                                        var json = jsonDecode(response.body);
                                        var chatroom =
                                            json['chatRoom']['messages'];
                                        String currentuser =
                                            json['currentUser']['name'];
                                        int user = json['currentUser']['id'];
                                        String userIdchatr = user.toString();
                                        int chatroomcurrent =
                                            json['chatRoom']['id'];
                                        String chatroomcurrentId =
                                            chatroomcurrent.toString();
                                        // print(chatroom);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ChatScreen(
                                                  user: currentuser,
                                                  messagechatroom: chatroom,
                                                  chatroomuserId: userIdchatr,
                                                  chatroomcurrent:
                                                      chatroomcurrentId),
                                            ));
                                      } else {
                                        print("kcbj");
                                      }
                                    }
                                  },
                                )
                              : Text("No Notifications to display yet"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
        },
      ),
    );
  }
}
