import 'package:emo_chat/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserState with ChangeNotifier {
  User _user;
  User get user => _user;

  void setUser(FirebaseUser firebaseUser) async {
    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result =
      await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(firebaseUser.uid).setData(
          {
            'nickname': firebaseUser.displayName,
            'photoUrl': firebaseUser.photoUrl,
            'id': firebaseUser.uid,
            'email': firebaseUser.email
          },);
      }


      _user = User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName,
        photoUrl: firebaseUser.photoUrl,
        email: firebaseUser.photoUrl,
      );
      notifyListeners();
    }
  }
}
