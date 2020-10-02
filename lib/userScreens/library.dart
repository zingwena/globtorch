import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Everything you need on e-learning"),
          ],
        ),
      ),
    );
  }
}
