import 'package:emo_chat/models/user.dart';

class FirebaseUserMapper {
  User mapUser(Map<String, dynamic> map) {
    return User(id: map["id"], name: map["nickname"], email: map["email"], photoUrl: map["photoUrl"]);
  }
}
