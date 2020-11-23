import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopicViw extends StatefulWidget {
  final Map<String, dynamic> contentname;
  final String contentnaming;
  const TopicViw({Key key, this.contentname, this.contentnaming})
      : super(key: key);
  @override
  _TopicViwState createState() =>
      _TopicViwState(contentname: contentname, content: contentnaming);
}

class _TopicViwState extends State<TopicViw> {
  final Map<String, dynamic> contentname;

  final String content;
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;

  @override
  void initState() {
    super.initState();
    getConnect(); // calls getconnect method to check which type if connection it
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
    }
  }

  _TopicViwState({this.contentname, this.content});
  PDFDocument _doc;
  bool _loading;
  @override
  Widget build(BuildContext context) {
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
                              child: Text(content,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  )))),
                      SizedBox(height: 10),
                      Text("Topic Content",
                          style: TextStyle(
                              color: Color(0xff59595a), fontSize: 15)),
                    ])),
            centerTitle: true,
          )),
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
                              final status = await Permission.storage.request();
                              if (isInternetOn) {
                                if (status.isGranted) {
                                  //print(contentname['topic']);
                                  for (var contentloop in contentname['topic']
                                      ['contents']) {
                                    if (contentloop['type'] == 'pdf') {
                                      var contentID = contentloop['id'];
                                      String stringcontentID =
                                          contentID.toString();

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      var token = prefs.getString('api_token');
                                      final url =
                                          "https://globtorch.com/api/contents/$stringcontentID?api_token=$token";

                                      setState(() {
                                        _loading = true;
                                      });
                                      final doc =
                                          await PDFDocument.fromURL(url);
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
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
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
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text(
                                            "You are no longer connected to the internet"),
                                        content: Text(
                                            "Please turn on wifi or mobile data"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: new Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
