import 'package:emo_chat/models/message.dart';
import 'package:emo_chat/models/user.dart';

class FirebaseMessageMapper {
  Message mapMessage(Map<String, dynamic> map) {
    return Message(map["idFrom"], map["idTo"], map["content"], map["hapiness"], map["isEye"]);
  }
}
