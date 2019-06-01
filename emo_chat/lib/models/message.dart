import 'package:emo_chat/models/user.dart';

class Message {
  final String from;
  final String to;
  final String content;
  final double hapiness;
  final bool isEye;

  Message(this.from, this.to, this.content, this.hapiness, this.isEye);

}
