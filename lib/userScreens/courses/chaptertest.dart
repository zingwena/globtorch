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
  bool selected = false;

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
                    child: Card(
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'A:',
                                ),
                                Checkbox(
                                    value: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value;
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
                                    value: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value;
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
                                    value: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value;
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
                                    value: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value;
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
                  ),
                ],
              ),
            );
          }),
    );
  }
}
