import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/chat/screens/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoriteContacts extends StatelessWidget {
  final chtrm;

  const FavoriteContacts({Key key, this.chtrm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 120.0,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: chtrm == null ? 0 : chtrm.length,
              itemBuilder: (BuildContext context, int index) {
                if (chtrm == null) {
                  return GestureDetector(
                    child: Text("No Favourates to display"),
                  );
                } else
                  return GestureDetector(
                    onTap: () async {
                      int id = chtrm[index]['id'];

                      String chatroomId = id.toString();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var token = prefs.getString('api_token');
                      final url =
                          "https://globtorch.com/api/chat_room/$chatroomId?api_token=$token";
                      http.Response response = await http
                          .get(url, headers: {"Accept": "application/json"});
                      var json = jsonDecode(response.body);
                      var chatroom = json['chatRoom']['messages'];
                      int user = json['currentUser']['id'];
                      String userIdchatr = user.toString();
                      int chatroomcurrent = json['chatRoom']['id'];
                      String chatroomcurrentId = chatroomcurrent.toString();
                      // print(chatroom);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                                user: chtrm[index]['name'],
                                messagechatroom: chatroom,
                                chatroomuserId: userIdchatr,
                                chatroomcurrent: chatroomcurrentId),
                          ));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            child: Icon(Icons.person),
                            radius: 25.0,
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            chtrm[index]['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
