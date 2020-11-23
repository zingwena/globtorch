import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    this.user,
    this.messagechatroom,
    this.chatroomuserId,
    this.chatroomcurrent,
  });
  final messagechatroom;
  final String chatroomuserId;
  final chatroomcurrent;

  final user;
  @override
  _ChatScreenState createState() => _ChatScreenState(
      chatroomitems: messagechatroom,
      chatuserId: chatroomuserId,
      username: user,
      chatroomcurrentId: chatroomcurrent);
}

class _ChatScreenState extends State<ChatScreen> {
  final chatroomitems;
  final String chatuserId;
  final chatroomcurrentId;
  var username;

  _ChatScreenState(
      {this.chatroomcurrentId,
      this.chatuserId,
      this.chatroomitems,
      this.username});
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

  final TextEditingController _textController = TextEditingController();
  // AnimationController animationController;
  final GlobalKey<ScaffoldState> scafoldState = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  _buildMessage(final message, bool isMe, date) {
    return Container(
      margin: !isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: !isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: !isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          !isMe
              ? Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  message,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          SizedBox(height: 8.0),
          Text(
            date,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: Form(
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _textController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You cannot send an empty message';
                  }
                  return null;
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message...',
                ),
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                if (isInternetOn) {
                  if (_formKey.currentState.validate()) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');
                    String msg = _textController.text;
                    String url =
                        'https://globtorch.com/api/chat_room?api_token=$token';
                    final response = await http.post(url, headers: {
                      "Accept": "Application/json"
                    }, body: {
                      'message': msg,
                      'chat_room_id': chatroomcurrentId,
                      'current_user_id': chatuserId
                    });
                    var convertedDatatoJson = jsonDecode(response.body);
                    _textController.clear();
                    if (response.statusCode == 200) {
                      scafoldState.currentState.showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.white,
                          content: const Text(
                            'your message has been succesifully sent \n it will updated Shortly',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      );
                    }

                    print(convertedDatatoJson);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text(
                            "You are no longer connected to the internet"),
                        content: Text("Please turn on wifi or mobile data"),
                        actions: <Widget>[
                          FlatButton(
                            child: new Text("OK"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen()));
                              //Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldState,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          username,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 15.0),
                      itemCount:
                          chatroomitems == null ? 0 : chatroomitems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final message = chatroomitems[index]['message'];
                        final date = chatroomitems[index]['created_at'];
                        final bool isMe =
                            chatroomitems[index]['user_id'] == chatuserId;
                        if (chatroomitems == null) {
                          return Container(
                            child: Text("No Message to display"),
                          );
                        } else
                          return _buildMessage(
                            message,
                            isMe,
                            date,
                          );
                      },
                    ),
                  ),
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ),
      ),
    );
  }
}
