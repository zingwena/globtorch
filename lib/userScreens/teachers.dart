import 'package:flutter/material.dart';
import 'package:globtorch/tools/seperator.dart';
import 'package:globtorch/userScreens/rate_a_teacher.dart';

class MyTeachers extends StatefulWidget {
  final myteachers;

  const MyTeachers({this.myteachers});
  @override
  _MyTeachersState createState() => _MyTeachersState(listteachers: myteachers);
}

class _MyTeachersState extends State<MyTeachers> {
  final listteachers;

  _MyTeachersState({this.listteachers});
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
                                child: Text("My Teachers",
                                    style: TextStyle(
                                        color: Color(0xff59595a),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)))),
                        SizedBox(height: 10),
                      ])),
              centerTitle: true,
            )),
        body: ListView.builder(
            itemCount: listteachers == null ? 0 : listteachers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(30)),
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: Container(
                    child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.person, color: Colors.black, size: 70.0),
                            Text(
                              "${listteachers[index]["name"]} ${listteachers[index]["surname"]}",
                            ),
                            Separator(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                      padding: const EdgeInsets.all(8.0),
                                      textColor: Colors.white,
                                      color: Colors.indigo[300],
                                      onPressed: () async {},
                                      child: Text(
                                        "See Profile",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: RaisedButton(
                                      padding: const EdgeInsets.all(8.0),
                                      textColor: Colors.white,
                                      color: Colors.indigo[300],
                                      onPressed: () async {
                                        int id = listteachers[index]['id'];
                                        String teacherId = id.toString();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        RateTeacher(
                                                            idofteacher:
                                                                teacherId)));
                                      },
                                      child: Text(
                                        "Rate Teacher",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
                color: Colors.grey[300],
              );
            }));
  }
}
