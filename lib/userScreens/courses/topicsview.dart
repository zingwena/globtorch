import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopicViw extends StatefulWidget {
  final Map<String, dynamic> contentname;

  const TopicViw({Key key, this.contentname}) : super(key: key);
  @override
  _TopicViwState createState() => _TopicViwState(
        contentname: contentname,
      );
}

class _TopicViwState extends State<TopicViw> {
  final Map<String, dynamic> contentname;

  _TopicViwState({this.contentname});
  PDFDocument _doc;
  bool _loading;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: new Text("Topic Content"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: contentname == null ? 0 : contentname.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SingleChildScrollView(
                      child: Html(
                    data: """${contentname['slides']}""",
                    blockSpacing: 14.0,
                  )),
                  ListTile(
                    /* leading: new CircleAvatar(
                      backgroundColor: Colors.red,
                      child: new Icon(
                        Icons.file_download,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),*/
                    title: Container(
                      child: Container(
                        width: 10.0,
                        height: 40.0,
                        child: FlatButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0)),
                            onPressed: () async {
                              for (var contentloop in contentname['topic']
                                  ['contents']) {
                                if (contentloop['type'] == 'pdf') {
                                  var contentID = contentloop['id'];
                                  String stringcontentID = contentID.toString();

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  var token = prefs.getString('api_token');
                                  final url =
                                      "https://globtorch.com/api/contents/$stringcontentID?api_token=$token";

                                  setState(() {
                                    _loading = true;
                                  });
                                  final doc = await PDFDocument.fromURL(url);
                                  setState(() {
                                    _doc = doc;
                                    _loading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => _loading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : PDFViewer(
                                                  document: _doc,
                                                  indicatorBackground:
                                                      Colors.red,
                                                  showPicker: true,
                                                  showIndicator: true,
                                                )));
                                }
                              }
                            },
                            child: Text(
                              "View content in pdf",
                              style: TextStyle(fontSize: 20.0),
                            )),
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
