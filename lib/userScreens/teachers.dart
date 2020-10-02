import 'package:flutter/material.dart';

class MyTeachers extends StatefulWidget {
  @override
  _MyTeachersState createState() => _MyTeachersState();
}

class _MyTeachersState extends State<MyTeachers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Teachers'),
      ),
      body: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text('School Teachers')],
        ),
      ),
    );
  }
}
