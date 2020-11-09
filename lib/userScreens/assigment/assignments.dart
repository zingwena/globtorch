import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/assigment/assignmenttable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Assignments extends StatelessWidget {
  final listasignmnts;
  final String subname;
  const Assignments({
    Key key,
    this.listasignmnts,
    this.subname,
  }) : super(key: key);
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
                          child: Text(subname,
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
        itemCount: listasignmnts == null ? 0 : listasignmnts.length,
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
                            "${listasignmnts[index]['name']}",
                            style: TextStyle(color: Colors.blue[600]),
                          ),
                          trailing: Column(
                            children: <Widget>[
                              Icon(Icons.date_range),
                              Text("Due Date"),
                              Expanded(
                                child: Text(
                                    "${listasignmnts[index]['due_date']}",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                          onTap: () async {
                            int assignmentId = listasignmnts[index]['id'];
                            String assignmentIdStrng = assignmentId.toString();
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
