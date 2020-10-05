import 'package:flutter/material.dart';

class AssignmentDetails extends StatelessWidget {
  final assignmentdetails;

  const AssignmentDetails({Key key, this.assignmentdetails}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Assignment Details"),
          backgroundColor: Colors.green,
        ),
        body: Container(
          child: Center(
            child: (Column(children: [
              Text(assignmentdetails['name']),
              Text(assignmentdetails['due_date']),
              FlatButton(
                onPressed: () {},
                child: Text("Download Assignment"),
                color: Colors.red,
              )
            ])),
          ),
        ));
  }
}
