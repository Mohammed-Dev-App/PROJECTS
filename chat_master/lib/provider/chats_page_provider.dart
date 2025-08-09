import 'dart:async';

//Model
import 'package:chat_master/models/chat_masseges.dart';

//Provider
import 'package:chat_master/provider/authentication_provider.dart';

//Services
import 'package:chat_master/services/database_service.dart';
import 'package:chat_master/services/media_service.dart';
import 'package:chat_master/services/navigation_service.dart';
import 'package:chat_master/services/supa_storage_service.dart';
//Packages
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:file_picker/file_picker.dart';

class ChatsPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late SupaStorageService _storage;
  late MediaService _media;
  late NavigationService _navigaion;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatId;
  List<ChatMessages>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibiltyStream;
  late KeyboardVisibilityController _keyboardVisibilityController;
  String? _message;

  String? get message {
    return _message;
  }

  set message(String? value) {
    _message = value;
  }

  ChatsPageProvider(
    this._chatId,
    this._auth,
    this._messagesListViewController,
  ) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<SupaStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigaion = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToKeyboardChanges();
    listenToMessages();
  }
  @override
  void dispose() {
    _messagesStream.cancel();
    _keyboardVisibiltyStream.cancel();

    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(_chatId).listen((_snapshot) {
        List<ChatMessages> _messages =
            _snapshot.docs.map((e) {
              Map<String, dynamic> _messageData =
                  e.data() as Map<String, dynamic>;
              return ChatMessages.fromJSON(_messageData);
            }).toList();
        messages = _messages;
        print("Messages vlue    ${messages![0].content}");
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messagesListViewController.hasClients) {
            _messagesListViewController.jumpTo(
              _messagesListViewController.position.maxScrollExtent,
            );
          }
        });

        //Add Scroll To Bottom Call
      });
    } catch (e) {
      print("Error getting Messages");
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    try {
      _keyboardVisibiltyStream = _keyboardVisibilityController.onChange.listen((
        bool _event,
      ) {
        print("_chatId $_chatId _event $_event");
        _db.updateChatData(_chatId, {'is_activity': _event});
      });
    } catch (e) {
      print("Error reading keyboard State");
    }
  }

  void sendTextMessage() {
    print(_message);
    if (_message != null) {
      ChatMessages _messageToSend = ChatMessages(
        senderId: _auth.user.uid,
        type: MessagesType.TEXT,
        content: _message!,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  Future<void> sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadUrl = await _storage.saveChatImageToStorage(
          _chatId,
          _auth.user.uid,
          _file,
        );

        ChatMessages _messageToSend = ChatMessages(
          senderId: _auth.user.uid,
          type: MessagesType.IMAGE,
          content: _downloadUrl!,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print("Error sending Image Message");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigaion.goBack();
  }
}
