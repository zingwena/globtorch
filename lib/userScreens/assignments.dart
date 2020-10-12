import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/assignmentdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Assignments extends StatelessWidget {
  final listasignmnts;
  const Assignments({Key key, this.listasignmnts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: new Text("My Assignments"),
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
                            final assgnmentJson = json;
                            //print(assgnmentJson['name']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AssignmentDetails(
                                            assignmentdetails: assgnmentJson)));
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
