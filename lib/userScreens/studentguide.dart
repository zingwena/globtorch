import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class StudentGuide extends StatefulWidget {
  @override
  _StudentGuideState createState() => _StudentGuideState();
}

class _StudentGuideState extends State<StudentGuide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[400],
          title: new Text("Globtorch "),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
                child: Column(
              children: [
                Container(
                  height: 50,
                  color: Colors.white,
                  child: Center(
                      child: TyperAnimatedTextKit(
                    text: [
                      "Student Guide is comming soon , Please Stay with us!"
                    ],
                    isRepeatingAnimation: true,
                  )),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
          ],
        ));
  }
}
