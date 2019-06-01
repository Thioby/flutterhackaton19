import 'package:emo_chat/style/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(Images.arrowBack),
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
      );
}
