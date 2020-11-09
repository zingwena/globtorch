import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/assigment/assignmenttable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  const Notifications({this.not});

  @override
  _NotificationsState createState() => _NotificationsState(notific: not);
  final List not;
}

class _NotificationsState extends State<Notifications> {
  final List notific;
  _NotificationsState({this.notific});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: notific == null ? 0 : notific.length,
        itemBuilder: (BuildContext context, int index) {
          print(notific);
          return Container(
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      child: Card(
                        child: ListTile(
                          title: Text(notific[index]['title']),
                          onTap: () async {
                            var navtonotidetails =
                                notific[index]['link'].toString();
                            List<String> strings = navtonotidetails.split("/");
                            var lastindex = strings[strings.length - 1];
                            if (strings.contains("viewassign")) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var token = prefs.getString('api_token');
                              final urlAssignment =
                                  "https://globtorch.com/api/assignments/$lastindex?api_token=$token";
                              http.Response response = await http.get(
                                  urlAssignment,
                                  headers: {"Accept": "application/json"});
                              var json = jsonDecode(response.body);
                              //print(json);
                              var assgnmentJson = json;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AssignmentList(
                                            assignmentdetails: assgnmentJson,
                                          )));
                            } else {
                              print("not");
                            }
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
    );
  }
}
