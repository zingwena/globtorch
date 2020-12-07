import 'dart:isolate';
import 'dart:ui';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:globtorch/userScreens/courses/topicpdf.dart';
import 'package:path_provider/path_provider.dart';
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

  ReceivePort _receivePort = ReceivePort();
  bool isDeviceConnected = false;

  @override
  initState() {
    super.initState();
    getConnect();
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    // _receivePort.listen((message) {
    //   setState(() {
    //     progress = message[2];
    //   });

    //   //print(progress);
    // });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
    }
  }

  _TopicViwState({this.contentname, this.content});
  bool _loading = true;

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
                              if (isDeviceConnected) {
                                print(contentname['topic']['contents']);
                                if (status.isGranted) {
                                  for (var contentloop in contentname['topic']
                                      ['contents']) {
                                    if (contentloop['type'] == 'pdf') {
                                      var contentID = contentloop['id'];
                                      print(contentID);
                                      String stringcontentID =
                                          contentID.toString();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      var token = prefs.getString('api_token');
                                      final url =
                                          "https://globtorch.com/api/contents/$stringcontentID?api_token=$token";
                                      final filename = contentloop['name'];
                                      final filepath = contentloop['path'];
                                      final externalDir =
                                          await getExternalStorageDirectory();
                                      final id =
                                          await FlutterDownloader.enqueue(
                                        url:
                                            "https://globtorch.com/api/contents/$stringcontentID?api_token=$token",
                                        savedDir: externalDir.path,
                                        fileName: "$filepath",
                                        showNotification: true,
                                        openFileFromNotification: true,
                                      );
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PDFTopic(
                                                      name: filename,
                                                      path: filepath,
                                                      link: url)));
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
