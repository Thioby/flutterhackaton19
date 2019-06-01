import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => _getItem(context, index),
                itemCount: getItemsCount(),
              ),
            ),
            Row(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "Type message",
                  ),
                ),
                FlatButton(
                  child: Text("Send"),
                  onPressed: () => {},
                )
              ],
            )
          ],
        ));
  }

  int getItemsCount() => 200;

  Container _getItem(BuildContext context, int index) {
    if (index % 2 == 0)
      return _getParentMessage(context, "Rudy Nowak", "elo makrelo");

    return _getMessage(context, "Niebieski Nowak", "elo makrelo");
  }

  Container _getParentMessage(
          BuildContext context, String _name, String text) =>
      Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getNameText(_name, context),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text,
                          style: TextStyle(color: Colors.black54)),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0x99FFFBE9E7),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )));

  Text _getNameText(String _name, BuildContext context) => Text(_name,
      style: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ));

  Container _getMessage(BuildContext context, String _name, String text) =>
      Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getNameText(_name, context),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0x99FFBBDEFB),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )));

  AppBar _appBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text("Chat"),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
      );
}
