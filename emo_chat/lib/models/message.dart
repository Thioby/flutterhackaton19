import 'package:emo_chat/models/user.dart';

class Message {
  final User from;
  final User to;
  final String content;
  final String chatId;
  final double hapiness;
  final bool isEye;

  Message(this.from, this.to, this.content, this.chatId, this.hapiness, this.isEye);

}
