import 'package:flutter/material.dart';
import 'package:globtorch/userScreens/chat/chatpage.dart';
import 'package:globtorch/userScreens/chat/flat_widgets/flat_action_btn.dart';
import 'package:globtorch/userScreens/chat/flat_widgets/flat_chat_item.dart';
import 'package:globtorch/userScreens/chat/flat_widgets/flat_page_header.dart';
import 'package:globtorch/userScreens/chat/flat_widgets/flat_page_wrapper.dart';
import 'package:globtorch/userScreens/chat/flat_widgets/flat_profile_image.dart';
import 'package:globtorch/userScreens/chat/flat_widgets/flat_section_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatHomepage extends StatefulWidget {
  const ChatHomepage({this.chatroomlist});

  @override
  _ChatHomepageState createState() =>
      _ChatHomepageState(listchatroom: chatroomlist);
  final chatroomlist;
}

class _ChatHomepageState extends State<ChatHomepage> {
  final listchatroom;

  _ChatHomepageState({this.listchatroom});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: listchatroom == null ? 0 : listchatroom.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        child: FlatPageWrapper(
                          scrollType: ScrollType.floatingHeader,
                          header: FlatPageHeader(
                            prefixWidget: FlatActionButton(
                              iconData: Icons.menu,
                            ),
                            title: "Globtorch Chat",
                            suffixWidget: FlatActionButton(
                              iconData: Icons.search,
                            ),
                          ),
                          children: [
                            FlatSectionHeader(
                              title: "Recent Chats",
                            ),
                            Container(
                              height: 76.0,
                              margin: EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  FlatProfileImage(
                                    imageUrl:
                                        "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=80",
                                    onlineIndicator: true,
                                    outlineIndicator: true,
                                  ),
                                ],
                              ),
                            ),
                            FlatSectionHeader(
                              title: "Chats",
                            ),
                            FlatChatItem(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext ctx) =>
                                            ChatPage()));
                              },
                              name: listchatroom[index]['name'],
                              profileImage: FlatProfileImage(
                                imageUrl:
                                    "https://cdn.dribbble.com/users/1281912/avatars/normal/febecc326c76154551f9d4bbab73f97b.jpg?1468927304",
                                onlineIndicator: true,
                              ),
                              message:
                                  "Hello World!, Welcome to Flat Social - Flutter UI Kit.",
                              multiLineMessage: true,
                            ),
                            FlatChatItem(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext ctx) =>
                                            ChatPage()));
                              },
                              name: "Akshaye JH",
                              profileImage: FlatProfileImage(
                                imageUrl:
                                    "https://cdn.dribbble.com/users/1281912/avatars/normal/febecc326c76154551f9d4bbab73f97b.jpg?1468927304",
                                onlineIndicator: true,
                              ),
                              message:
                                  "Hello World!, Welcome to Flat Social - Flutter UI Kit.",
                              multiLineMessage: true,
                            ),
                            FlatChatItem(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext ctx) =>
                                            ChatPage()));
                              },
                              name: "Akshaye JH",
                              profileImage: FlatProfileImage(
                                imageUrl:
                                    "https://cdn.dribbble.com/users/1281912/avatars/normal/febecc326c76154551f9d4bbab73f97b.jpg?1468927304",
                                onlineIndicator: true,
                              ),
                              message:
                                  "Hello World!, Welcome to Flat Social - Flutter UI Kit.",
                              multiLineMessage: true,
                            ),
                            FlatChatItem(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext ctx) =>
                                            ChatPage()));
                              },
                              name: "Akshaye JH",
                              profileImage: FlatProfileImage(
                                imageUrl:
                                    "https://cdn.dribbble.com/users/1281912/avatars/normal/febecc326c76154551f9d4bbab73f97b.jpg?1468927304",
                                onlineIndicator: true,
                              ),
                              message:
                                  "Hello World!, Welcome to Flat Social - Flutter UI Kit.",
                              multiLineMessage: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
