import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_chat/models/message.dart';
import 'package:flutter/foundation.dart';

class MessageState with ChangeNotifier {
  void sendMessage(Message content) async {
    String messageContent = content.content;
    if (messageContent.trim() != '') {
      var documentReference = Firestore.instance
          .collection('messages')
          .document(content.chatId)
          .collection(content.chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': content.from.id,
            'idTo': content.to.id,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': messageContent,
            'isEye': content.isEye,
            'hapiness': content.hapiness
          },
        );
      });
    }
  }
}
