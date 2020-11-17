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
          title: Text('Progress Report'),
          centerTitle: false,
        ),
        body: Center(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Table(
                border: TableBorder.all(),
                columnWidths: {
                  0: FractionColumnWidth(.6),
                  1: FractionColumnWidth(.4),
                },
                children: [
                  TableRow(children: [
                    Column(children: [Text('My Account')]),
                    Column(children: [Text('Settings')]),
                  ]),
                  TableRow(children: [
                    Icon(
                      Icons.cake,
                      size: 10.0,
                    ),
                    Icon(
                      Icons.voice_chat,
                      size: 10.0,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        )));
  }
}
