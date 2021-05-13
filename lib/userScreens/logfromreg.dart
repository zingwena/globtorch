import 'package:Globtorch/tools/constants.dart';
import 'package:Globtorch/userScreens/HomePage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogInFromRegistration extends StatefulWidget {
  const LogInFromRegistration({Key key, this.id}) : super(key: key);

  @override
  _LogInFromRegistrationState createState() =>
      _LogInFromRegistrationState(schoolId: id);
  final String id;
}

class _LogInFromRegistrationState extends State<LogInFromRegistration> {
  final String schoolId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _rememberMe = false;
  bool visible = false;
  bool isLoading = true;
  String message;
  bool isDeviceConnected = false;

  _LogInFromRegistrationState({this.schoolId});

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
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildLogInDetails(),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildLoginBtn(),
                      // _buildForgotPasswordBtn(),
                      _buildRememberMeCheckbox(),
                      SizedBox(
                        height: 10.0,
                      ),
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

  Widget _buildLogInDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Successifully registered, Please take this School ID for LogIn $schoolId',
          style: TextStyle(color: Colors.yellow),
        ),
        SizedBox(height: 40.0),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'School ID',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: usernameController,
            validator: (input) {
              if (input.isEmpty) {
                return 'Provide an email/UserID';
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
              hintText: 'Enter your Email/UserID',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
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
            controller: passwordController,
            validator: (input) {
              if (input.length < 6) {
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
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: signIn,
        //   if (rsp['data'].containsKey('isEnabled')) {
        //     setState(() {
        //       message = rsp['isEnabled'];
        //     });
        //     if (rsp['data']['isEnabled'] == 1) {
        //       Navigator.push(context, MaterialPageRoute(builder: (context) {
        //         return HomePage();
        //       }));
        //     }
        //   } else {
        //     setState(() {
        //       message = 'Login Failed';
        //     });
        //   }
        // },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    if (_formKey.currentState.validate()) {
      String username = usernameController.text;
      String password = passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      _formKey.currentState.save();
      setState(() {
        visible = true;
        isLoading = true;
      });
      if (isDeviceConnected) {
        String url = 'https://globtorch.com/api/login';
        final response = await http.post(url,
            headers: {"Accept": "Application/json"},
            body: {'school_id': username, 'password': password});
        var convertedDatatoJson = jsonDecode(response.body);
        var token = convertedDatatoJson['api_token'];
        final urlnot =
            "https://www.globtorch.com/api/notifications?api_token=$token";
        http.Response responsenot =
            await http.get(urlnot, headers: {"Accept": "application/json"});
        var json = jsonDecode(responsenot.body);
        print(json);
        var notIn = json['num_unread_notifications'];
        var notifinumber = notIn.toString();
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            setState(() {
              visible = false;
            });
          }

          prefs.setString('email', convertedDatatoJson['data']['email']);
          prefs.setString('name', convertedDatatoJson['data']['name']);
          prefs.setString('surname', convertedDatatoJson['data']['surname']);
          prefs.setString(
              'api_token', convertedDatatoJson['data']['api_token']);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(
                        name: convertedDatatoJson['data']['name'],
                        surname: convertedDatatoJson['data']['surname'],
                        email: convertedDatatoJson['data']['email'],
                        notific: notifinumber,
                      )),
              (Route<dynamic> route) => false);
        } else if (response.statusCode == 400 || response.statusCode == 401) {
          if (mounted) {
            setState(() {
              visible = false;
            });
          }
          String mesg = convertedDatatoJson['message'].toString().trim();
          String error = convertedDatatoJson['errors'].toString().trimLeft();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text(
                  '$mesg $error',
                  style: TextStyle(color: Colors.red),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => LogIn()));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Authentication Error"),
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
      } else
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("No internet connection"),
              content: Text("Please turn on wifi or mobile data"),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogInFromRegistration()));
                    //Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
    }
  }
}
