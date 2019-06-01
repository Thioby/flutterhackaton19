import 'package:emo_chat/models/user.dart';

String getChatId(User current, User peer) {
  var currentId = current.id;
  var peerId = peer.id;

  if (currentId.hashCode <= peerId.hashCode) {
    return '$currentId-$peerId';
  } else {
    return '$peerId-$currentId';
  }
}
