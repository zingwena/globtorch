import 'package:flutter/material.dart';

class Discussions extends StatefulWidget {
  @override
  _DiscussionsState createState() => _DiscussionsState();
}

class _DiscussionsState extends State<Discussions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discussions"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Lets discuss about the importance of e-learning"),
          ],
        ),
      ),
    );
  }
}
