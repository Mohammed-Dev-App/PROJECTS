import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/database_service.dart';

import '../provider/authentication_provider.dart';

import '../models/chat.dart';
import '../models/chat_masseges.dart';
import '../models/chat_user.dart';

class ChatPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _db;

  List<Chat>? chats;

  late StreamSubscription _chatStream;
  ChatPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      print(_auth.user.uid);
      _chatStream = _db.getChatsForUser(_auth.user.uid).listen((
        _snapshot,
      ) async {
        chats = await Future.wait(
          _snapshot.docs.map((_d) async {
            Map<String, dynamic> _chatData = _d.data() as Map<String, dynamic>;
            //Get Users In Chat
            List<ChatUser> members = [];
            for (var _uid in _chatData['members']) {
              DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
              Map<String, dynamic> _userData =
                  _userSnapshot.data() as Map<String, dynamic>;
              _userData['uid'] = _userSnapshot.id;
              members.add(ChatUser.fromJSON(_userData));
            }
            //Get Last Message For Chat
            List<ChatMessages> messages = [];
            QuerySnapshot _chatMessages = await _db.getLastMessageForChat(
              _d.id,
            );
            if (_chatMessages.docs.isNotEmpty) {
              Map<String, dynamic> _messageData =
                  _chatMessages.docs.first.data() as Map<String, dynamic>;
              ChatMessages _message = ChatMessages.fromJSON(_messageData);
              messages.add(_message);
            }

            //Return Chat Instance
            return Chat(
              uid: _d.id,
              curentUserUid: _auth.user.uid,
              activity: _chatData['is_activity'],
              group: _chatData['is_group'],
              members: members,
              messages: messages,
            );
          }).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print("Error getting Chats");
      print(e);
    }
  }
}
