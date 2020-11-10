import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  State createState() => ChatWindow();
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Application"),
        elevation: Theme.of(ctx).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
          reverse: true,
          padding: EdgeInsets.all(6.0),
        )),
        Divider(height: 1.0),
        Container(
          child: _buildComposer(),
          decoration: BoxDecoration(color: Theme.of(ctx).cardColor),
        ),
      ]),
    );
  }

  Widget _buildComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration: InputDecoration.collapsed(
                      hintText: "Enter some text to send a message"),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null)
                      : IconButton(
                          icon: Icon(Icons.message),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null,
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = Msg(
      txt: txt,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;

  String defaultUserName = "John Doe";

  @override
  Widget build(BuildContext ctx) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: CircleAvatar(child: Text(defaultUserName[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(defaultUserName,
                      style: Theme.of(ctx).textTheme.subtitle1),
                  Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: Text(txt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
