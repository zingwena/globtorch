import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/chat/widgets/favorite_contacts.dart';
import 'package:globtorch/userScreens/chat/widgets/recent_chats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.chtrom, this.chatsusers});

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(listchtroom: chtrom, chatuse: chatsusers);
  final chtrom;
  final chatsusers;
}

class _HomeScreenState extends State<HomeScreen> {
  final listchtroom;
  final chatuse;
  _HomeScreenState({this.chatuse, this.listchtroom});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text(
          'Globtorch Chat',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  FavoriteContacts(chtrm: listchtroom),
                  RecentChats(chatroomusers: chatuse),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
