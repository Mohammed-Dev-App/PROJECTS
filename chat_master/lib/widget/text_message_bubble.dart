//package
import 'package:chat_master/models/chat_masseges.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextMessageBubble extends StatelessWidget {
  final double width;
  final double hieght;
  final bool isOwnMessage;
  final ChatMessages message;
  const TextMessageBubble({
    super.key,
    required this.width,
    required this.hieght,
    required this.isOwnMessage,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorSchema =
        isOwnMessage
            ? [
              Color.fromRGBO(0, 136, 249, 1.0),
              Color.fromRGBO(0, 82, 218, 1.0),
            ]
            : [
              Color.fromRGBO(51, 49, 68, 1.0),
              Color.fromRGBO(51, 49, 68, 1.0),
            ];
    return Container(
      //  height: hieght + (message.content.length / 20 * 6.0),
      constraints: BoxConstraints(
        minHeight: hieght + (message.content.length / 20 * 6.0),
      ),
      width: width * 0.99,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: _colorSchema,
          stops: [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(message.content, style: TextStyle(color: Colors.white)),
          Text(
            timeago.format(message.sentTime),
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
