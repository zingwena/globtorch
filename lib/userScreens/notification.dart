import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({this.not});

  @override
  _NotificationsState createState() => _NotificationsState(notific: not);
  final List not;
}

class _NotificationsState extends State<Notifications> {
  final List notific;

  _NotificationsState({this.notific});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: notific == null ? 0 : notific.length,
        itemBuilder: (BuildContext context, int index) {
          print(notific);
          return Container(
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      child: Card(
                        child: ListTile(
                          title: Text(notific[index]['title']),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
