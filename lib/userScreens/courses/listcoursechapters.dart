import 'package:Globtorch/tools/style.dart';
import 'package:Globtorch/userScreens/courses/listcoursetopics.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ListChapters extends StatefulWidget {
  final List coursechapters;
  final String subname;
  ListChapters({this.coursechapters, this.subname});

  @override
  _ListChaptersState createState() =>
      _ListChaptersState(subnamee: subname, coursechapterss: coursechapters);
}

class _ListChaptersState extends State<ListChapters> {
  final List coursechapterss;
  final String subnamee;

  _ListChaptersState({this.coursechapterss, this.subnamee});
  bool isDeviceConnected = false;

  @override
  void initState() {
    super.initState();
    getConnect(); // calls getconnect method to check which type if connection it
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            backgroundColor: Colors.green.shade900,
            flexibleSpace: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(subnamee,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )))),
                      SizedBox(height: 10),
                      Text("Subject Chapters",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ])),
            centerTitle: true,
          )),
      body: ListView.builder(
          itemCount: coursechapterss == null ? 0 : coursechapterss.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: <Widget>[
                  // Text(
                  //   "$coursename",
                  //   style: Style.titleTextStyle,
                  // ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Card(
                          child: ListTile(
                            title: Text(
                              "${coursechapterss[index]['name']}",
                              style: Style.headerTextStyle,
                            ),
                            subtitle: Container(
                                padding:
                                    new EdgeInsets.symmetric(horizontal: 50.0),
                                child: FlatButton(
                                  onPressed: () {
                                    int id = coursechapterss[index]['id'];
                                    String stringId = id.toString();
                                    var topicname =
                                        coursechapterss[index]['name'];
                                    List coursetopics =
                                        coursechapterss[index]['topics'];
                                    Navigator.of(context).push(
                                        new CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                new ListTopicsContent(
                                                  coursetopics: coursetopics,
                                                  tpcname: topicname,
                                                  idChapter: stringId,
                                                )));
                                  },
                                  child: const Text(
                                    'View Topics',
                                  ),
                                  color: Color.fromRGBO(161, 108, 164, 1.0),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  textColor: Colors.white,
                                )),
                            dense: true,
                            onTap: () {
                              var topicname = coursechapterss[index]['name'];
                              List coursetopics =
                                  coursechapterss[index]['topics'];
                              Navigator.of(context).push(new CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      new ListTopicsContent(
                                          coursetopics: coursetopics,
                                          tpcname: topicname)));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
