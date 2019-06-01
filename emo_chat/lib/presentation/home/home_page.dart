import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_chat/infrastructure/firebase_user_mapper.dart';
import 'package:emo_chat/infrastructure/firestrore_tables.dart';
import 'package:emo_chat/presentation/chat/chat_page.dart';
import 'package:emo_chat/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              var currentUser = Provider.of<UserState>(context);

              if (!snapshot.hasData) {
                return _buildLoading();
              }
              List<DocumentSnapshot> userRawList = snapshot.data.documents;
              var filteredList = userRawList.where((element) => element.data["id"] != currentUser.user.id).toList();

              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  return _buildItem(context, filteredList[index]);
                },
                itemCount: filteredList.length,
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
        onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(user)))},
      ),
    );
  }

  AppBar _appBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text(
          "Face2Face",
          style: TextStyle(color: Colors.deepOrange, shadows: [
            BoxShadow(color: Colors.white, blurRadius: 10),
          ]),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
      );
}
