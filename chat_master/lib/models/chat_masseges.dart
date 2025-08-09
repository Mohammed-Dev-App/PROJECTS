import 'package:cloud_firestore/cloud_firestore.dart';

enum MessagesType { TEXT, IMAGE, UNKOWN }

class ChatMessages {
  final String senderId;
  final MessagesType type;
  final String content;
  final DateTime sentTime;

  ChatMessages({
    required this.senderId,
    required this.type,
    required this.content,
    required this.sentTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "sender_id": senderId,
      "type": type.toString().split('.').last.toLowerCase(),
      "content": content,
      "sent_time": Timestamp.fromDate(sentTime),
    };
  }

  factory ChatMessages.fromJSON(Map<String, dynamic> _json) {
    MessagesType _messagesType;
    switch (_json['type']) {
      case "text":
        _messagesType = MessagesType.TEXT;
        break;
      case "image":
        _messagesType = MessagesType.IMAGE;
        break;
      default:
        _messagesType = MessagesType.UNKOWN;
    }

    return ChatMessages(
      senderId: _json['sender_id'],
      type: _messagesType,
      content: _json['content'],
      sentTime: (_json['sent_time'] as Timestamp).toDate(),
    );
  }
}
