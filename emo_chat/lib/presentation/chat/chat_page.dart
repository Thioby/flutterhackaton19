import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        child: ListView.builder(
//        key: categoriesKey,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => _getItem(),
          itemCount: getItemsCount(),
        ),
      ),
    );
  }

  int getItemsCount() => 0;

  Container _getItem() => Container();

  AppBar _appBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text("Chat"),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
      );
}
