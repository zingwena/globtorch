import 'dart:ui';

import 'package:flutter/material.dart';

class TestChapters extends StatefulWidget {
  final List testquestions;

  TestChapters({Key key, this.testquestions}) : super(key: key);
  @override
  _TestChaptersState createState() =>
      _TestChaptersState(questionchapter: testquestions);
}

class _TestChaptersState extends State<TestChapters> {
  final List questionchapter;
  _TestChaptersState({this.questionchapter});
  List<bool> _isChecked1;
  List<bool> _isChecked2;
  List<bool> _isChecked3;
  List<bool> _isChecked4;
  String answera;
  String answerb;
  String answerc;
  String answerd;
  String answer;
  int numofquestn;
  List<int> myList = List<int>();
  @override
  void initState() {
    super.initState();
    _isChecked1 = List<bool>.filled(questionchapter.length, false);
    _isChecked2 = List<bool>.filled(questionchapter.length, false);
    _isChecked3 = List<bool>.filled(questionchapter.length, false);
    _isChecked4 = List<bool>.filled(questionchapter.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount:
                        questionchapter == null ? 0 : questionchapter.length,
                    itemBuilder: (BuildContext context, int index) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          answer = questionchapter[index]['answer'];
                          numofquestn = questionchapter.length;
                        });
                      });

                      return Container(
                        height: 400.0,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              child: Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              questionchapter[index]
                                                  ['question'],
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'A:',
                                          ),
                                          Checkbox(
                                              value: _isChecked1[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value = true) {
                                                    _isChecked1[index] = value;
                                                    answera =
                                                        questionchapter[index]
                                                            ['answer_a'];
                                                    _isChecked2[index] = false;
                                                    _isChecked3[index] = false;
                                                    _isChecked4[index] = false;
                                                    myList.add(index);
                                                  }
                                                });
                                              }),
                                          Expanded(
                                            child: Text(
                                              questionchapter[index]
                                                  ['answer_a'],
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'B:',
                                          ),
                                          Checkbox(
                                              value: _isChecked2[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value = true) {
                                                    _isChecked2[index] = value;
                                                    answerb =
                                                        questionchapter[index]
                                                            ['answer_b'];
                                                    _isChecked1[index] = false;
                                                    _isChecked3[index] = false;
                                                    _isChecked4[index] = false;
                                                    myList.add(index);
                                                  }
                                                });
                                              }),
                                          Expanded(
                                              child: Text(
                                            questionchapter[index]['answer_b'],
                                            overflow: TextOverflow.clip,
                                          )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'C:',
                                          ),
                                          Checkbox(
                                              value: _isChecked3[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value = true) {
                                                    _isChecked3[index] = value;
                                                    answerc =
                                                        questionchapter[index]
                                                            ['answer_c'];
                                                    _isChecked2[index] = false;
                                                    _isChecked1[index] = false;
                                                    _isChecked4[index] = false;
                                                    myList.add(index);
                                                  }
                                                });
                                              }),
                                          Expanded(
                                            child: Text(
                                              questionchapter[index]
                                                  ['answer_c'],
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'D:',
                                          ),
                                          Checkbox(
                                              value: _isChecked4[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value = true) {
                                                    _isChecked4[index] = value;
                                                    answerd =
                                                        questionchapter[index]
                                                            ['answer_d'];
                                                    _isChecked2[index] = false;
                                                    _isChecked3[index] = false;
                                                    _isChecked1[index] = false;
                                                    myList.add(index);
                                                  }
                                                });
                                              }),
                                          Expanded(
                                            child: Text(
                                              questionchapter[index]
                                                  ['answer_d'],
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            SizedBox(
              height: 50.0,
              child: FlatButton.icon(
                onPressed: () {
                  print(myList);
                  // for (var i = 0; i <= numofquestn; i++) {
                  //   print(i);
                  // }
                  // if (_isChecked1[0] = true) {
                  //   debugPrint(answera);
                  // } else if (_isChecked2[1] = true) {
                  //   print(answerb);
                  // } else if (_isChecked3[2] = true) {
                  //   print(answerc);
                  // } else if (_isChecked4[3] = true) {
                  //   print(answerd);
                  // }
                },
                label: Icon(Icons.send),
                icon: Text(
                  "Submit",
                  overflow: TextOverflow.clip,
                ),
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ));
  }
}
