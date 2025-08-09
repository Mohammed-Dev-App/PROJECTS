import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/rounded_image_network.dart';
import '../widget/image_message_bubble.dart';
import '../widget/text_message_bubble.dart';

import '../models/chat_masseges.dart';
import '../models/chat_user.dart';

class CustomListViewTile extends StatelessWidget {
  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;
  CustomListViewTile({
    super.key,
    required this.height,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isSelected ? Icon(Icons.check, color: Colors.white) : null,
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetWorkWithStatusIndecator(
        key: UniqueKey(),
        imagePath: imagePath,
        size: height / 2,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white54,
        ),
      ),
      selected: isSelected,
      selectedTileColor: isSelected ? Colors.blue.withOpacity(0.15) : null,
    );
  }
}

class CustomListView extends StatelessWidget {
  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;
  CustomListView({
    super.key,
    required this.height,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetWorkWithStatusIndecator(
        key: UniqueKey(),
        imagePath: imagePath,
        size: height / 2,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:
          isActivity
              ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    color: Colors.white54,
                    size: height * 0.10,
                  ),
                ],
              )
              : Text(
                subTitle,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
    );
  }
}

class CustomChatListView extends StatelessWidget {
  final double width;
  final double deviceHieght;
  final bool isOwnMessage;
  final ChatMessages message;
  final ChatUser sender;
  const CustomChatListView({
    super.key,
    required this.width,
    required this.deviceHieght,
    required this.message,
    required this.sender,
    required this.isOwnMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      width: width,
      // height: deviceHieght,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                imagePath: sender.imageURL,
                size: width * 0.08,
              )
              : Container(),
          SizedBox(width: width * 0.05),
          message.type == MessagesType.TEXT
              ? TextMessageBubble(
                width: width * 0.96,
                isOwnMessage: isOwnMessage,
                hieght: deviceHieght * 0.06,
                message: message,
              )
              : ImageMessageBubble(
                width: width * 0.5,
                hieght: deviceHieght * 0.30,
                isOwnMessage: isOwnMessage,
                message: message,
              ),
        ],
      ),
    );
  }
}
