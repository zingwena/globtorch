import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:globtorch/tools/animation.dart';
import 'package:globtorch/tools/seperator.dart';
import 'package:globtorch/tools/style.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:globtorch/tools/constants.dart';
import 'package:flutter/services.dart';
import 'package:globtorch/userScreens/loginpage.dart';
import 'dart:async';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  String _dropDownValue;
  final fnameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final referralController = TextEditingController();
  final passwordControlller = TextEditingController();
  String _fname, _surname, _phone, _email, _country, _password, _referals;
  // Boolean variable for CircularProgressIndicator.
  bool visible = false;
  bool isLoading = true;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildFirstNamelTF(),
                      SizedBox(height: 30.0),
                      _buildSurnameTF(),
                      SizedBox(height: 30.0),
                      _buildPhoneTF(),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(height: 30.0),
                      _buildCountryTF(),
                      SizedBox(height: 30.0),
                      _buildPasswordTF(),
                      SizedBox(height: 30.0),
                      _buildReferralTF(),
                      _buildSignUpBtn(),
                      _buildSignInBtn(),
                      Visibility(
                          visible: visible,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.red),
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNamelTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'FirstName',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: fnameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Provide First Name';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your First Name',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (input) => _fname = input,
          ),
        ),
      ],
    );
  }

  Widget _buildSurnameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Surname',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: surnameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Provide a Surname';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your Surname',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (input) => _surname = input,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: phoneController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Provide Phone Number';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              hintText: 'Enter your Phone Number',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (input) => _phone = input,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emailController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Provide an email';
              } else if (!(regex.hasMatch(value))) {
                return "Invalid Email";
              }

              return null;
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (input) => _email = input,
          ),
        ),
      ],
    );
  }

  Widget _buildCountryTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Enter your Contry',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: countryController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Provide a country';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.public,
                color: Colors.white,
              ),
              hintText: 'Enter your Country',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (input) => _country = input,
          ),
        ),
      ],
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     DropdownButtonFormField(
    //       validator: (val) => val == null ? 'Please selecte a country' : null,
    //       hint: _dropDownValue == null
    //           ? Text(
    //               'Select Yor Country',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontFamily: 'OpenSans',
    //               ),
    //             )
    //           : Text(
    //               _dropDownValue,
    //               style: TextStyle(color: Colors.white),
    //             ),
    //       items: [
    //         'Algeria',
    //         'Angola',
    //         'Benin',
    //         'Botswana',
    //         'Burkina Faso',
    //         'Burundi',
    //         'Cameroon',
    //         'Cape Verde',
    //         'Central African Republic',
    //         'Chad',
    //         'Camoros',
    //         'DRC',
    //         'Djibouti',
    //         'Egypt',
    //         'Equatorial Guinea',
    //         'Eritrea',
    //         'Ethiopia',
    //         'Gabon',
    //         'Gambia',
    //         'Ghana',
    //         'Guinea',
    //         'Guinea-Bissau',
    //         'Ivory Coast',
    //         'Kenya',
    //         'Lesotho',
    //         'Liberia',
    //         'Libya',
    //         'Madagascar',
    //         'Malawi',
    //         'Mali',
    //         'Mauritania',
    //         'Mauritius',
    //         'Morocco',
    //         'Mozambique',
    //         'Namibia',
    //         'Niger',
    //         'Nigeria',
    //         'Rwanda',
    //         'Sao Tome',
    //         'Principe',
    //         'Senegal',
    //         'Seychelles',
    //         'Sierra Leone',
    //         'Somalia',
    //         'South Africa',
    //         'South Sudan',
    //         'Sudan',
    //         'Swaziland',
    //         'Tanzania',
    //         'Togo',
    //         'Tunisia',
    //         'Uganda',
    //         'Zambia',
    //         'Zimbabwe',
    //       ].map(
    //         (val) {
    //           return DropdownMenuItem<String>(
    //             value: val,
    //             child: Text(val),
    //           );
    //         },
    //       ).toList(),
    //       onChanged: (val) {
    //         setState(
    //           () {
    //             _dropDownValue = val;
    //           },
    //         );
    //       },
    //       onSaved: (input) => _country = input,
    //     ),
    //   ],
    // );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: passwordControlller,
            validator: (value) {
              if (value.length < 6) {
                return 'Longer password please';
              }
              return null;
            },
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (input) => _password = input,
          ),
        ),
      ],
    );
  }

  Widget _buildReferralTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Referrals',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: referralController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Provide Referrals(if any)?',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (input) => _referals = input,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    var raisedButton = RaisedButton(
      elevation: 5.0,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => _selectCourseToPay(),
                  fullscreenDialog: true));
        }
      },
      padding: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.white,
      child: Text(
        'SIGNUP',
        style: TextStyle(
          color: Color(0xFF527DAA),
          letterSpacing: 1.5,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: raisedButton,
    );
  }

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: navigateToSignIn,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  List listcourses;
  Future fetchCourses() async {
    http.Response response = await http.get("https://globtorch.com/api/courses",
        headers: {"Accept": "application/json"});
    var json = jsonDecode(response.body);
    setState(() {
      listcourses = json;
    });

    //debugPrint(listcourses.toString());
  }

  Widget _selectCourseToPay() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          //Color(0xFF398AE5),
          Colors.blueAccent,
          Colors.red,
          Colors.green,
        ])),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeAnimation(
                  2,
                  Text(
                    "Select a Course",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60))),
              child: ListView.builder(
                itemCount: listcourses == null ? 0 : listcourses.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(30),
                        side: BorderSide(
                            width: 8, color: Colors.greenAccent[700])),
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/globt.jpg'),
                            ),
                            Text(
                              "${listcourses[index]["name"]}",
                              style: Style.titleTextStyle,
                            ),
                            Text(
                              "${listcourses[index]["price"]}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${listcourses[index]["level"]}",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Separator(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  width: 30.0,
                                ),
                                new Expanded(
                                  child: new RaisedButton(
                                      padding: const EdgeInsets.all(8.0),
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      onPressed: () async {
                                        int id = listcourses[index]['id'];
                                        String fname = fnameController.text;
                                        String sname = surnameController.text;
                                        String phone = phoneController.text;
                                        String email = emailController.text;
                                        String country = countryController.text;
                                        String pwd = passwordControlller.text;
                                        String referral =
                                            referralController.text;
                                        _formKey.currentState.save();

                                        // Showing CircularProgressIndicator using State.
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: new Text(
                                                "Please wait......",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              actions: <Widget>[
                                                Visibility(
                                                    visible: visible,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 20),
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Colors.red),
                                                      ),
                                                    ))
                                              ],
                                            );
                                          },
                                        );
                                        setState(() {
                                          visible = true;
                                          isLoading = true;
                                        });
                                        // API URL
                                        String url =
                                            'https://globtorch.com/api/signup';

                                        // Store all data with Param Name.

                                        var data = {
                                          'name': fname,
                                          'surname': sname,
                                          'phone': phone,
                                          'email': email,
                                          'country': country,
                                          'password': pwd,
                                          'course_id': id,
                                          'paynow_ref': referral,
                                        };
                                        print(jsonEncode(data));

                                        // Starting Web Call with data.
                                        final response = await http.post(url,
                                            body: jsonEncode(data),
                                            headers: {
                                              "Accept": "application/json",
                                              "Content-type": "application/json"
                                            });
                                        var convertedDatatoJson =
                                            jsonDecode(response.body);
                                        //print(convertedDatatoJson);
                                        //print(response.statusCode);

                                        if (response.statusCode == 422) {
                                          setState(() {
                                            visible = false;
                                          });
                                          String mesg =
                                              convertedDatatoJson['message']
                                                  .toString()
                                                  .trim();
                                          String error =
                                              convertedDatatoJson['errors']
                                                  .toString()
                                                  .trimLeft();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: new Text(
                                                  '$mesg $error',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: new Text("OK"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else if (response.statusCode == 200) {
                                          String schoolId =
                                              convertedDatatoJson['data']
                                                  ['school_id'];
                                          setState(() {
                                            visible = false;
                                          });

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: new Text(
                                                  "Successifully registered, Please take this ID for LogIn $schoolId",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: new Text("Login"),
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      LogIn()));
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: new Text("Pay Now")),
                                ),
                              ],
                            ),
                          ],
                        )),
                    color: Colors.blue[500],
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void navigateToSignIn() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LogIn(), fullscreenDialog: true));
  }
}
