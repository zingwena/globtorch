import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RateTeacher extends StatefulWidget {
  final String idofteacher;
  final String teachersurname;
  final String teachername;

  const RateTeacher(
      {Key key, this.idofteacher, this.teachersurname, this.teachername})
      : super(key: key);
  @override
  _RateTeacherState createState() => _RateTeacherState(
      teacherId: idofteacher, name: teachername, surname: teachersurname);
}

class _RateTeacherState extends State<RateTeacher> {
  final String teacherId;
  final String name;
  final String surname;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController rateController = TextEditingController();
  var rating = 0.0;

  _RateTeacherState({this.name, this.surname, this.teacherId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                              child: Text("Rate",
                                  style: TextStyle(
                                      color: Color(0xff59595a),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)))),
                      SizedBox(height: 10),
                      Text("$name $surname")
                    ])),
            centerTitle: true,
          )),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                Text("Score Rate:"),
                SizedBox(
                  width: 20.0,
                ),
                SmoothStarRating(
                  color: Colors.redAccent,
                  rating: rating,
                  size: 30,
                  starCount: 5,
                  onRated: (value) {
                    setState(() {
                      rating = value;
                    });
                    // print(rating);
                  },
                  allowHalfRating: false,
                ),
              ],
            ),
            Text(
              "Please note that yur name will appear to the teacher , but we would like to contact you to address your issue!!",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        "Comment",
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLength: 2000,
                    controller: rateController,
                    decoration: InputDecoration.collapsed(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        hintText: null),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 300.0, right: 10.0),
              child: RaisedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    String commentTeacher = rateController.text;
                    int rate = rating.toInt();
                    String ratings = rate.toString();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');
                    final Map<String, dynamic> data = {
                      'comment': commentTeacher,
                      'teacher_id': teacherId,
                      'score': ratings
                    };
                    final url =
                        "https://globtorch.com/api/ratings?api_token=$token";
                    http.Response response = await http.post(url,
                        headers: {"Accept": "application/json"}, body: data);
                    var json = jsonDecode(response.body);
                    print(json);
                    rateController.clear();
                    if (response.statusCode == 200) {
                      _formKey.currentState.reset();
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(
                              json['status'],
                              style: TextStyle(color: Colors.green),
                            ),
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
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(
                              "Failed to rate a teacher",
                              style: TextStyle(color: Colors.red),
                            ),
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
                    /*  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text(
                      'Successifully add a discussion!',
                      style: TextStyle(color: Colors.green),
                    )));
                     Navigator.push(
                        (context),
                         MaterialPageRoute(
                             builder: (BuildContext context) => Discussions(
                                subname: subjectname,
                                discussionlist: discusionlist,
                                idsub: subId)));
                                */
                  }
                },
                textColor: Colors.green,
                label: Icon(Icons.navigate_next),
                icon: Text("Send"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.green)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
