import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/chat/screens/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecentChats extends StatelessWidget {
  final chatroomusers;

  const RecentChats({Key key, this.chatroomusers}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            itemCount: chatroomusers == null ? 0 : chatroomusers.length,
            itemBuilder: (BuildContext context, int index) {
              final chat = chatroomusers[index];
              if (chatroomusers == null) {
                return GestureDetector(
                  child: Container(child: Text("No results to display")),
                );
              } else
                return GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('api_token');
                    int id = chat['id'];
                    String userId = id.toString();
                    final url =
                        "https://globtorch.com/api/chat_room/create/$userId?api_token=$token";
                    http.Response response = await http
                        .get(url, headers: {"Accept": "application/json"});
                    var json = jsonDecode(response.body);
                    int user = json['currentUser']['id'];
                    String userIdchatr = user.toString();
                    int chatroomcurrent = json['chatRoom']['id'];
                    String chatroomcurrentId = chatroomcurrent.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                              user: chat['name'],
                              chatroomuserId: userIdchatr,
                              chatroomcurrent: chatroomcurrentId),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      //color: chat. ? Color(0xFFFFEFEE) :
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 35.0,
                              child: Icon(Icons.person),
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  chat['name'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Text(
                                    "",
                                    //chat.text,
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "",
                              //chat.time,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            /*  chat.
                              ? Container(
                                  width: 40.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Text(''),
                              */
                          ],
                        ),
                      ],
                    ),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}
