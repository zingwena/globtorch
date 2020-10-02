import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:link/link.dart';

class ExtResources extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[400],
          title: new Text("External Resources"),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.white,
                    child: Center(
                        child: TyperAnimatedTextKit(
                      text: ["Below are links to awarding bodies:"],
                      isRepeatingAnimation: true,
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Link(
                      url:
                          "https://www.accaglobal.com/gb/en/qualifications/accountancy-career/fees/fees-charges-ssa.html?countrycode=Zimbabwe",
                      child: ListTile(
                        title:
                            Text("ACCA", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    color: Colors.indigo,
                  ),
                  Card(
                    child: Link(
                        url: "http://www.iac.co.zw/",
                        child: ListTile(
                          title: Text("IAC",
                              style: TextStyle(color: Colors.white)),
                        )),
                    color: Colors.teal,
                  ),
                  Card(
                    child: Link(
                        url: "https://www.zimsec.co.zw/resources/",
                        child: ListTile(
                          title: Text("ZIMSEC",
                              style: TextStyle(color: Colors.white)),
                        )),
                    color: Colors.red,
                  ),
                  Card(
                    child: Link(
                        url:
                            "https://www.cambridgeinternational.org/programmes-and-qualifications/cambridge-upper-secondary/cambridge-igcse/subjects/",
                        child: ListTile(
                          title: Text("CAMBIDGE",
                              style: TextStyle(color: Colors.white)),
                        )),
                    color: Colors.yellow[600],
                  ),
                  Card(
                    child: Link(
                        url: "https://papers.xtremepape.rs/CAIE/IGCSE/",
                        child: ListTile(
                          title: Text(
                            "XTREME PAPERS",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    color: Colors.deepPurple[900],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
