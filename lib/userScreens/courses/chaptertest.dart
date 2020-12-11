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
  List<bool> _selection;
  @override
  void initState() {
    super.initState();
    _isChecked1 = List<bool>.filled(questionchapter.length, false);
    _isChecked2 = List<bool>.filled(questionchapter.length, false);
    _isChecked3 = List<bool>.filled(questionchapter.length, false);
    _isChecked4 = List<bool>.filled(questionchapter.length, false);
    _selection = List<bool>.filled(questionchapter.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: ListView.builder(
          itemCount: questionchapter == null ? 0 : questionchapter.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 400.0,
              child: Column(
                children: [
                  SingleChildScrollView(
                      child: Column(children: [
                    //   Text(
                    //     questionchapter[index]['question'],
                    //     overflow: TextOverflow.clip,
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    //   CheckboxListTile(
                    //     title: Column(
                    //       children: [
                    //         Text(questionchapter[index]['answer_a']),
                    //         Text(questionchapter[index]['answer_a']),
                    //         Text(questionchapter[index]['answer_a']),
                    //         Text(questionchapter[index]['answer_a']),
                    //       ],
                    //     ),
                    //     value: _selection[index],
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _selection[index] = value;
                    //       });
                    //     },
                    //   ),
                    // ],

                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    questionchapter[index]['question'],
                                    overflow: TextOverflow.clip,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //     children: <Widget>[
                          //       Expanded(
                          //         child: Text(
                          //           "Please Select One Answer!",
                          //           overflow: TextOverflow.clip,
                          //           style: TextStyle(
                          //             fontStyle: FontStyle.italic,
                          //             color: Colors.lightGreen,
                          //           ),
                          //           textAlign: TextAlign.center,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'A:',
                                ),
                                CheckboxListTile(
                                    value: _isChecked1[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked1[index] = value;
                                        String selectedanswer =
                                            _isChecked1[index].toString();
                                      });
                                    }),
                                Expanded(
                                    child: Text(
                                  questionchapter[index]['answer_a'],
                                  overflow: TextOverflow.clip,
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'B:',
                                ),
                                Checkbox(
                                    value: _isChecked2[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked2[index] = value;
                                      });
                                    }),
                                Expanded(
                                  child: Text(
                                    questionchapter[index]['answer_b'],
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'C:',
                                ),
                                Checkbox(
                                    value: _isChecked3[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked3[index] = value;
                                      });
                                    }),
                                Expanded(
                                  child: Text(
                                    questionchapter[index]['answer_c'],
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'D:',
                                ),
                                Checkbox(
                                    value: _isChecked4[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked4[index] = value;
                                      });
                                    }),
                                Expanded(
                                  child: Text(
                                    questionchapter[index]['answer_d'],
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
                ],
              ),
            );
          }),
    );
  }
}
