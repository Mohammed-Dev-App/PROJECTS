import 'package:chat_master/pages/chats_page.dart';
import 'package:chat_master/provider/authentication_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Service
import '../services/database_service.dart';
import '../services/navigation_service.dart';

//Model
import '../models/chat.dart';
import '../models/chat_user.dart';

class UserPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _databaseService;
  late NavigationService _navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;
  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UserPageProvider(this._auth) {
    _selectedUsers = [];
    // _auth = GetIt.instance.get<AuthenticationProvider>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }
  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      print("getusers   ${_databaseService.getUsers(name: name)} ");
      _databaseService.getUsers(name: name).then((_snapshot) {
        users =
            _snapshot.docs.map((_doc) {
              Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
              _data['uid'] = _doc.id;

              return ChatUser.fromJSON(_data);
            }).toList();
        notifyListeners();
      });
    } catch (e) {
      print(e);
      print("Error getting Users");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateSelectedUser(ChatUser _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> _membersId =
          _selectedUsers.map((_user) => _user.uid).toList();
      _membersId.add(_auth.user.uid);
      bool _isGroup = _selectedUsers.length > 1;
      DocumentReference? _doc = await _databaseService.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _membersId,
      });
      List<ChatUser> _members = [];
      for (var _uid in _membersId) {
        DocumentSnapshot _userSnapshot = await _databaseService.getUser(_uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData['uid'] = _userSnapshot.id;
        _members.add(ChatUser.fromJSON(_userData));
      }
      ChatsPage _chatsPage = ChatsPage(
        chat: Chat(
          uid: _doc!.id,
          curentUserUid: _auth.user.uid,
          activity: false,
          group: _isGroup,
          members: _members,
          messages: [],
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(_chatsPage);
    } catch (e) {
      print("Error creating chat");
      print(e);
    }
  }
}
