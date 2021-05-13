import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:link/link.dart';

class Library extends StatefulWidget {

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  
  /* @override
  void initState() {
    super.initState();
    getConnect(); // calls getconnect method to check which type if connection it
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[400],
          title: new Text("Globtorch Library"),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
              child: 
                 Column(
                      children: [
                        Container(
                          height: 50,
                          color: Colors.white,
                          child: Center(
                              child: TyperAnimatedTextKit(
                            text: [
                              "Click the link below to navigate to our Library"
                            ],
                            isRepeatingAnimation: true,
                          )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: Link(
                            url: "https://library.globtorch.com/",
                            child: ListTile(
                              title: Text("Library",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          color: Colors.indigo,
                        ),
                      ],
                    )
                 
            ),
          ],
        ));
  }
}
