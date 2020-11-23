import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globtorch/tools/style.dart';
import 'package:globtorch/userScreens/courses/listcoursetopics.dart';

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
                              child: Text(subnamee,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  )))),
                      SizedBox(height: 10),
                      Text("Subject Chapters",
                          style: TextStyle(
                              color: Color(0xff59595a), fontSize: 15)),
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
                                    var topicname =
                                        coursechapterss[index]['name'];
                                    List coursetopics =
                                        coursechapterss[index]['topics'];
                                    Navigator.of(context).push(
                                        new CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                new ListTopicsContent(
                                                    coursetopics: coursetopics,
                                                    tpcname: topicname)));
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
                              List coursetopics =
                                  coursechapterss[index]['topics'];
                              Navigator.of(context).push(new CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      new ListTopicsContent(
                                        coursetopics: coursetopics,
                                      )));
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
