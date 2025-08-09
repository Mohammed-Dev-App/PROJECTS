import 'package:chat_master/models/chat_user.dart';

import '../models/chat_masseges.dart';

class Chat {
  final String uid;
  final String curentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessages> messages;
  late final List<ChatUser> _recepints;

  Chat({
    required this.uid,
    required this.curentUserUid,
    required this.activity,
    required this.group,
    required this.members,
    required this.messages,
  }) {
    _recepints = members.where((_i) => _i.uid != curentUserUid).toList();
  }
  List<ChatUser> recepints() {
    return _recepints;
  }

  String title() {
    return !group
        ? _recepints.first.name
        : _recepints.map((_user) => _user.name).join(", ");
  }

  String imageURL() {
    return !group
        ? _recepints.first.imageURL
        : "https://png.pngtree.com/png-clipart/20230927/original/pngtree-man-avatar-image-for-profile-png-image_13001882.png";
  }
}
