import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    this.user,
    this.messagechatroom,
    this.chatroomuserId,
  });
  final messagechatroom;
  final String chatroomuserId;
  final user;
  @override
  _ChatScreenState createState() => _ChatScreenState(
      chatroomitems: messagechatroom,
      chatuserId: chatroomuserId,
      username: user);
}

class _ChatScreenState extends State<ChatScreen> {
  final chatroomitems;
  final String chatuserId;

  var username;
  _ChatScreenState({this.chatuserId, this.chatroomitems, this.username});
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;
  AnimationController animationController;

  _buildMessage(final message, bool isMe, date) {
    String txt;
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    // print(message);
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
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _textController,
              onChanged: (String txt) {
                setState(() {
                  _isWriting = txt.length > 0;
                });
              },
              //onSubmitted: _submitMsg,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () {}
              //_isWriting ? () => _submitMsg(_textController.text) : null,
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: GestureDetector(
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
                    //reverse: true,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: chatroomitems == null ? 0 : chatroomitems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = chatroomitems[index]['message'];
                      final date = chatroomitems[index]['created_at'];
                      final bool isMe =
                          chatroomitems[index]['user_id'] == chatuserId;
                      return _buildMessage(message, isMe, date);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
