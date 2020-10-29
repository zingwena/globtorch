import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentList extends StatefulWidget {
  const AssignmentList({Key key, this.assignmentdetails}) : super(key: key);

  @override
  _AssignmentListState createState() =>
      _AssignmentListState(assgnmentD: assignmentdetails);
  final assignmentdetails;
}

/*
to figure out when a user visit the assignment ,, should be shown on the second time
*/
class _AssignmentListState extends State<AssignmentList> {
  final assgnmentD;

  _AssignmentListState({this.assgnmentD});
  double progress = 0;
  PlatformFile file;
  File absolutefilePath;
  Directory appDir;
  ReceivePort _receivePort = ReceivePort();
  FilePickerResult result;
  http.MultipartFile multipartFile;
  SharedPreferences prefs;
  var filename;
  var resultString;

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      //print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  void _openFileExplorer() async {
    prefs = await SharedPreferences.getInstance();
    // prefs.setString('email', convertedDatatoJson['data']['email']);

    result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    prefs.setString("result", result.toString());
    if (result != null) {
      try {
        setState(() {
          file = result.files.first;
        });
        prefs.setString("filename", file.name);
        prefs.setString("filepath", file.path);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;
    }
  }

  Future _uploadFile() async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('api_token');
    var filepath = prefs.getString('filepath');
    int idAss = assgnmentD['id'];
    final url =
        "https://globtorch.com/api/assignments/$idAss/answer/upload?api_token=$token";
    if (result != null) {
      var postUri = Uri.parse(url);
      http.MultipartRequest request =
          new http.MultipartRequest("POST", postUri);
      multipartFile =
          await http.MultipartFile.fromPath('file_upload', filepath);
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(assgnmentD);
        showDialog(
          context: context,
          child: new AlertDialog(
            title: Text("Successifully Uploaded an asignment"),
            content: Text("Take on another assignment"),
            actions: [
              new FlatButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: Text("Nothing to upload"),
          content: Text("Pick Assignment first"),
          actions: [
            new FlatButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  void setState(fn) async {
    super.setState(fn);
    prefs = await SharedPreferences.getInstance();
    filename = prefs.getString('filename');
    resultString = prefs.getString('result');
  }

  @override
  Widget build(BuildContext context) {
    print(assgnmentD);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        flexibleSpace: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(assgnmentD['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
                  SizedBox(height: 10),
                  Text("Assignment Details",
                      style: TextStyle(color: Color(0xff59595a), fontSize: 15)),
                ])),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Table(columnWidths: {
          1: FractionColumnWidth(.3)
        }, children: [
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Time Send:")),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(assgnmentD['updated_at'])),
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Due Date:")),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(assgnmentD['due_date'])),
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Question:")),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: RaisedButton.icon(
                  color: Colors.red,
                  onPressed: () async {
                    final status = await Permission.storage.request();
                    String path = assgnmentD['file_path'];

                    int idAss = assgnmentD['id'];
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');
                    if (status.isGranted) {
                      final externalDir = await getExternalStorageDirectory();

                      final id = await FlutterDownloader.enqueue(
                        url:
                            "https://globtorch.com/api/assignments/$idAss/download?api_token=$token",
                        savedDir: externalDir.path,
                        fileName: "$path",
                        showNotification: true,
                        openFileFromNotification: true,
                      );

                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: Text("Download In progress"),
                          content: Text("Tap on Notifications"),
                          actions: [
                            new FlatButton(
                              child: const Text("Ok"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    } else {
                      print("Permission deined");
                    }
                  },
                  icon: Text('Download'),
                  label: Icon(Icons.file_download),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Upload:")),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: RaisedButton.icon(
                    onPressed: () => _openFileExplorer(),
                    icon: Text('upload'),
                    label: Icon(Icons.upload_file),
                    color: Colors.grey[200],
                  )),
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("File:")),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: resultString != null
                      ? Text(
                          filename,
                          textAlign: TextAlign.center,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "",
                          textAlign: TextAlign.center,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        )),
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Send:")),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: RaisedButton.icon(
                  onPressed: () => _uploadFile(),
                  icon: resultString != null ? Text('Update') : Text('Upload'),
                  label: Icon(Icons.upload_file),
                  color: Colors.green,
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Mark %:")),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: assgnmentD['mark'] != null
                      ? Text(assgnmentD['mark'])
                      : Text(
                          "Pending",
                          textAlign: TextAlign.center,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        )
                  //Text(assgnmentD['mark']),
                  )
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Marked Answer:")),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: assgnmentD['marked_answer'] != null
                      ? Text(assgnmentD['marked_answer'])
                      : resultString == null
                          ? Text(
                              "No upload yet",
                              textAlign: TextAlign.center,
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Pending",
                              textAlign: TextAlign.center,
                              style: new TextStyle(fontWeight: FontWeight.bold),
                            )

                  //Text(assgnmentD['marked_answer']),
                  )
            ],
          ),
          TableRow(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Answer:")),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: resultString != null
                      ? Text(
                          "Submited",
                          textAlign: TextAlign.center,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "No upload yet",
                          textAlign: TextAlign.center,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        )),
            ],
          ),
        ]),
      ),
    );
  }
}
