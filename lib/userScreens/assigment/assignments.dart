import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/assigment/assignmenttable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Assignments extends StatefulWidget {
  final listasignmnts;
  final String subname;
  const Assignments({
    Key key,
    this.listasignmnts,
    this.subname,
  }) : super(key: key);
  @override
  _AssignmentsState createState() =>
      _AssignmentsState(subnamee: subname, listasignmntss: listasignmnts);
}

class _AssignmentsState extends State<Assignments> {
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

  final listasignmntss;
  final String subnamee;

  _AssignmentsState({this.listasignmntss, this.subnamee});
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
                          child: Text(subnamee,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
                  SizedBox(height: 10),
                  Text("Subjects Assignments",
                      style: TextStyle(color: Color(0xff59595a), fontSize: 15)),
                ])),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: listasignmntss == null ? 0 : listasignmntss.length,
        itemBuilder: (BuildContext context, int index) {
          if (listasignmntss == null) {
            return Container(
              child: Column(
                children: [
                  Column(
                    children: [
                      Text("No Assignments to display"),
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
                          child: ListTile(
                            title: Text(
                              "${listasignmntss[index]['name']}",
                              style: TextStyle(color: Colors.blue[600]),
                            ),
                            onTap: () async {
                              if (isDeviceConnected) {
                                int assignmentId = listasignmntss[index]['id'];
                                String assignmentIdStrng =
                                    assignmentId.toString();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var token = prefs.getString('api_token');
                                final urlAssignment =
                                    "https://globtorch.com/api/assignments/$assignmentIdStrng?api_token=$token";
                                http.Response response = await http.get(
                                    urlAssignment,
                                    headers: {"Accept": "application/json"});
                                var json = jsonDecode(response.body);
                                var assgnmentJson = json;
                                //print(assgnmentJson['name']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            AssignmentList(
                                              assignmentdetails: assgnmentJson,
                                            )));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text(
                                          "You are no longer connected to the internet"),
                                      content: Text(
                                          "Please turn on wifi or mobile data"),
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
