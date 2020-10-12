import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AssignmentDetails extends StatefulWidget {
  @override
  _AssignmentDetailsState createState() =>
      _AssignmentDetailsState(assgnmentD: assignmentdetails);
  const AssignmentDetails({Key key, this.assignmentdetails}) : super(key: key);
  final assignmentdetails;
}

class _AssignmentDetailsState extends State<AssignmentDetails> {
  var assgnmentD;

  _AssignmentDetailsState({this.assgnmentD});

  double progress = 0;
  String _path = '';
  PlatformFile file;

  File absolutefilePath;
  Directory appDir;

  ReceivePort _receivePort = ReceivePort();

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
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null) {
      try {
        // absolutefilePath = File(
        //   result.files.single.path,
        // );
        setState(() {
          file = result.files.first;
        });
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;

      setState(() {});
    }
  }

  Future _uploadFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('api_token');
    int idAss = assgnmentD['id'];
    final url =
        "https://globtorch.com/api/assignments/$idAss/answer/upload?api_token=$token";

    /*final response = await http.post(url, headers: {
      "Accept": "Application/json"
    }, body: {
      'file_upload': file.name,
    });
    print(file.name);
    var convertedDatatoJson = jsonDecode(response.body);
    print(convertedDatatoJson);
*/
    if (file.name == null) {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: Text("No Assignment Selected"),
          content: Text("Select an assignment"),
          actions: [
            new FlatButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      var postUri = Uri.parse(url);

      http.MultipartRequest request =
          new http.MultipartRequest("POST", postUri);
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('file_upload', file.path);
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(assgnmentD);
    return Scaffold(
        appBar: AppBar(
          title: Text(assgnmentD['name']),
          backgroundColor: Colors.green,
        ),
        body: Container(
          color: Colors.grey[300],
          child: Center(
            child: (Column(children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Time Send:"),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    assgnmentD['updated_at'],
                    style: TextStyle(
                        color: Colors.green, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Due Date:"),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    assgnmentD['due_date'],
                    style: TextStyle(
                        color: Colors.green, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton.icon(
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
                icon: Text('Download Assignment'),
                label: Icon(Icons.file_download),
              ),
              SizedBox(
                height: 30.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: new Text(
                  "Pick an assignment answer below",
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton.icon(
                onPressed: () => _openFileExplorer(),
                icon: Text('Pick an Asignment'),
                label: Icon(Icons.upload_file),
                color: Colors.grey[200],
              ),
              new Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "file.name",
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 50.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: new Text(
                  "Upload an assignment answer below",
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton.icon(
                onPressed: () => _uploadFile(),
                icon: Text('Upload and Assignement'),
                label: Icon(Icons.upload_file),
                color: Colors.green,
              ),
            ])),
          ),
        ));
  }
}
