import 'package:flutter/material.dart';

class TeacherProfile extends StatefulWidget {
  final String name;
  final String surname;
  final String gender;
  final String phone;
  final String email;

  const TeacherProfile(
      {Key key, this.name, this.surname, this.gender, this.phone, this.email})
      : super(key: key);
  @override
  _TeacherProfileState createState() => _TeacherProfileState(
      teacheremail: email,
      teachername: name,
      teachergender: gender,
      teacherphone: phone,
      teachersurname: surname);
}

class _TeacherProfileState extends State<TeacherProfile> {
  final String teachername;
  final String teachersurname;
  final String teachergender;
  final String teacherphone;
  final String teacheremail;

  _TeacherProfileState(
      {this.teachername,
      this.teachersurname,
      this.teachergender,
      this.teacherphone,
      this.teacheremail});
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
                              child: Text("Profile For",
                                  style: TextStyle(
                                      color: Color(0xff59595a),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)))),
                      SizedBox(height: 10),
                      Text("$teachername $teachersurname")
                    ])),
            centerTitle: true,
          )),
      body: Container(
        color: Colors.blueGrey[50],
        child: Wrap(
          spacing: 2.0,
          runSpacing: 2.0,
          children: [
            Row(
              children: [
                Text("Name",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
                SizedBox(
                  width: 200.0,
                ),
                Text(teachername,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Text("Surname",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
                SizedBox(
                  width: 200.0,
                ),
                Text(teachersurname,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Text("Gender",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
                SizedBox(
                  width: 200.0,
                ),
                Text(teachergender,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Text("Email",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
                SizedBox(
                  width: 100.0,
                ),
                Text(teacheremail,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Text("Phone",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600)),
                SizedBox(
                  width: 200.0,
                ),
                Text(teacherphone,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade600)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
