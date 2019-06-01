import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_chat/infrastructure/firebase_user_mapper.dart';
import 'package:emo_chat/infrastructure/firestrore_tables.dart';
import 'package:emo_chat/presentation/chat/chat_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final FirebaseUserMapper userMapper = FirebaseUserMapper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance.collection(Tables.USERS).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildLoading();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) =>
                    _buildItem(context, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
              );
            }),
      ),
    );
  }

  Center _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot document) {
    var user = userMapper.mapUser(document.data);
    return Padding(
      padding: new EdgeInsets.all(20),
      child: FlatButton(
        child: Text(user.name),
        onPressed: () => {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatPage()))
            },
      ),
    );
  }

  AppBar _appBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text("Users"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
      );
}
