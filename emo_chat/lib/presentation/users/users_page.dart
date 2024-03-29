import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_chat/infrastructure/firebase_user_mapper.dart';
import 'package:emo_chat/infrastructure/firestrore_tables.dart';
import 'package:emo_chat/models/user.dart';
import 'package:emo_chat/presentation/chat/chat_page.dart';
import 'package:emo_chat/presentation/onboarding/onboarding_background.dart';
import 'package:emo_chat/presentation/users/user_row.dart';
import 'package:flutter/material.dart';

const PLACEHOLDER = "https://www.jpl.nasa.gov/spaceimages/images/thumbnailhires/PIA23006_hithumb.jpg";

class UsersPage extends StatelessWidget {
  final FirebaseUserMapper userMapper = FirebaseUserMapper();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Stack(
        children: <Widget>[
          OnboardingBackground(),
          Container(
            child: StreamBuilder(
                stream: Firestore.instance.collection(Tables.USERS).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return _buildLoading();
                  }
                  return ListView.separated(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => _buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    separatorBuilder: _buildSeparator,
                  );
                }),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text(
          "Face2Face",
          style: TextStyle(color: Colors.white, shadows: [
            BoxShadow(color: Colors.blue, blurRadius: 10),
          ],
          fontSize: 28),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
      );

  Center _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot document) {
    var user = userMapper.mapUser(document.data);
    return _buildRow(context, user);
  }

  Widget _buildRow(BuildContext context, User user) {
    return UserRow(user.name, user.photoUrl ?? PLACEHOLDER, () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(user)));
    });
  }

  Widget _buildSeparator(BuildContext context, index) {
    return Container(
      height: 10,
    );
  }
}
