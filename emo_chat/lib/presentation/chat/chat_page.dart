import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        child: ListView.builder(
//        key: categoriesKey,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => _getItem(context),
          itemCount: getItemsCount(),
        ),
      ),
    );
  }

  int getItemsCount() => 1;

  Container _getItem(BuildContext context) {
    return _getParentMessage(context, "Rudy Nowak", "elo makrelo");
  }

  Container _getParentMessage(
          BuildContext context, String _name, String text) =>
      Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  )
                ],
              ),
              decoration: BoxDecoration(color: Color(0x99FFFBE9E7))));

  AppBar _appBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text("Chat"),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
      );
}
