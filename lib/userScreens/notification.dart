import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:globtorch/userScreens/assigment/assignmenttable.dart';
import 'package:globtorch/userScreens/chat/screens/chat_screen.dart';
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
        itemBuilder: (BuildContext context, int index) {
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
                                    List<String> strings =
                                        navtonotidetails.split("/");
                                    var lastindex = strings[strings.length - 1];
                                    if (strings.contains("viewassign")) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var token = prefs.getString('api_token');
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
                                              builder: (BuildContext context) =>
                                                  AssignmentList(
                                                    assignmentdetails:
                                                        assgnmentJson,
                                                  )));
                                    } else if (strings.contains("chat_room")) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var token = prefs.getString('api_token');
                                      //"https://globtorch.com/api/chat_room?api_token=$token";
                                      final urlAssignment =
                                          "https://globtorch.com/api/chat_room?api_token=$token";
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
                                              builder: (BuildContext context) =>
                                                  ChatScreen()));
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
