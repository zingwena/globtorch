import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
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
  PlatformFile file;
  File absolutefilePath;
  Directory appDir;
  ReceivePort _receivePort = ReceivePort();
  FilePickerResult result;
  http.MultipartFile multipartFile;
  SharedPreferences prefs;
  var filename;
  var resultString;
  bool isDeviceConnected = false;
  @override
  void initState() {
    super.initState();
    getConnect(); // calls getconnect method to check which type if connection it
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

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
    }
  }

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort.send([id, status, progress]);
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
    if (isDeviceConnected) {
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("You are no longer connected to the internet"),
            content: Text("Please turn on wifi or mobile data"),
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

  @override
  void setState(fn) async {
    super.setState(fn);
    prefs = await SharedPreferences.getInstance();
    filename = prefs.getString('filename');
    resultString = prefs.getString('result');
  }

  @override
  Widget build(BuildContext context) {
    //print(multipartFile);

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
                                child: Text(assgnmentD['name'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    )))),
                        SizedBox(height: 10),
                        Text("Assignment Details",
                            style: TextStyle(
                                color: Color(0xff59595a), fontSize: 15)),
                      ])),
              centerTitle: true,
            )),
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
                  if (isDeviceConnected) {
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
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: Text("No permission allowed"),
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
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(
                              "You are no longer connected to the internet"),
                          content: Text("Please turn on wifi or mobile data"),
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
                icon: resultString != null
                    ? Text('Update and Assignement')
                    : Text('Upload and Assignement'),
                label: Icon(Icons.upload_file),
                color: Colors.green,
              ),
              Container(
                child: Center(
                  child: Text("data"),
                ),
              ),
            ])),
          ),
        ));
  }
}
