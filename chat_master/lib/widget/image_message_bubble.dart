//package
import 'package:chat_master/models/chat_masseges.dart';
import 'package:chat_master/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ImageMessageBubble extends StatelessWidget {
  final double width;
  final double hieght;
  final bool isOwnMessage;
  final ChatMessages message;
  const ImageMessageBubble({
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
    DecorationImage _image = DecorationImage(
      image: NetworkImage(message.content),
      fit: BoxFit.cover,
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MainPage(image: message.content);
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: hieght * 0.03,
          horizontal: width * 0.02,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: _colorSchema,
            stops: [0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: hieght,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: _image,
              ),
            ),
            SizedBox(height: hieght * 0.02),
            Text(
              timeago.format(message.sentTime),
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
