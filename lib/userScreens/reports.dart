import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Tab(
              text: 'Due date for Assignments 1 is 12/09/20',
            )
          ],
        ),
      ),
    );
  }
}
