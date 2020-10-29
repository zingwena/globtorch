import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globtorch/tools/constants.dart';
import 'package:globtorch/userScreens/HomePage.dart';
import 'package:globtorch/userScreens/signup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _rememberMe = false;
  // Boolean variable for CircularProgressIndicator.
  bool visible = false;
  bool isLoading = true;
  String message;

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
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildLoginBtn(),
                      // _buildForgotPasswordBtn(),
                      _buildRememberMeCheckbox(),
                      // _buildSocialBtnRow(),
                      _buildSignupBtn(),
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

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: navigateToSignUp,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
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

  void navigateToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpPage(), fullscreenDialog: true));
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
      String url = 'https://globtorch.com/api/login';
      final response = await http.post(url,
          headers: {"Accept": "Application/json"},
          body: {'school_id': username, 'password': password});
      var convertedDatatoJson = jsonDecode(response.body);
      //print(convertedDatatoJson);
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
        setState(() {
          visible = false;
        });
        prefs.setString('email', convertedDatatoJson['data']['email']);
        prefs.setString('name', convertedDatatoJson['data']['name']);
        prefs.setString('surname', convertedDatatoJson['data']['surname']);
        prefs.setString('api_token', convertedDatatoJson['data']['api_token']);

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
        setState(() {
          visible = false;
        });
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
//  final snackBar = SnackBar(
//             content: Text(body['message'].toString().trim()),
//         );
//         _scaffoldKey.currentState.showSnackBar(snackBar);
//     }
//     setState(() {
//         loading = false;
//     });
// });
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogIn()));
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
