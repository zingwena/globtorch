import 'dart:ui';

import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  final reportchapters;
  final reportresults;
  final namecourse;
  const Reports({this.reportchapters, this.reportresults, this.namecourse});
  @override
  _ReportsState createState() => _ReportsState(
      reptchapters: reportchapters,
      reptresults: reportresults,
      coursename: namecourse);
}

class _ReportsState extends State<Reports> {
  final coursename;
  final reptchapters;
  final reptresults;
  _ReportsState({this.reptresults, this.reptchapters, this.coursename});

  @override
  Widget build(BuildContext context) {
    var key = reptchapters.keys.toList();

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor: Colors.green[400],
              flexibleSpace: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(coursename,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    )))),
                        SizedBox(height: 10),
                        Text("Progress Report",
                            style: TextStyle(
                                color: Color(0xff59595a), fontSize: 15)),
                      ])),
              centerTitle: true,
            )),
        body: ListView.builder(
            itemCount: reptresults == null ? 0 : reptresults.length,
            itemBuilder: (BuildContext context, int index) {
              if (reptresults == null) {
                return Container(
                  child: Column(
                    children: [
                      Text("No results to display"),
                    ],
                  ),
                );
              } else
                return Container(
                    child: Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      reptresults[index]['subjectName'],
                      //reptchapters["${key[index]}"]['subjectName'],
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            child: Table(
                              border: TableBorder.all(),
                              columnWidths: {
                                0: FractionColumnWidth(.6),
                                1: FractionColumnWidth(.4),
                              },
                              children: [
                                TableRow(children: [
                                  Column(children: [
                                    Text(
                                      "Chapters",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                                  Column(children: [
                                    Text(
                                      'Percentages(%)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                                ]),
                                TableRow(children: [
                                  Column(children: [
                                    Text(reptresults[index]['chapterName'])
                                  ]),
                                  Column(children: [
                                    Text(
                                      reptresults[index]['percentage'],
                                    )
                                  ]),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
            }));
  }
}
