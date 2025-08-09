import 'package:chat_master/models/chat.dart';
import 'package:chat_master/models/chat_masseges.dart';
import 'package:chat_master/models/chat_user.dart';
import 'package:chat_master/provider/authentication_provider.dart';
import 'package:chat_master/provider/chat_page_provider.dart';
import 'package:chat_master/widget/custom_list_view.dart';
import 'package:chat_master/widget/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../pages/chats_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHieght;
  late double _deviceWidth;
  late NavigationService _navigationService;
  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHieght = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<ChatPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHieght * 0.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Chats',
                primaryAction: IconButton(
                  onPressed: () {
                    _auth.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              _ChatList(),
            ],
          ),
        );
      },
    );
  }

  Widget _ChatList() {
    List<Chat>? _chats = _pageProvider.chats;
    print(_chats);
    return Expanded(
      child:
          (() {
            if (_chats != null) {
              if (_chats.length != 0) {
                return ListView.builder(
                  itemCount: _chats.length,
                  itemBuilder: (context, index) {
                    return _ChatTile(_chats[index]);
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "No Chats Found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
          })(),
    );
  }

  Widget _ChatTile(Chat _chat) {
    List<ChatUser> _recepinet = _chat.recepints();
    bool _isActive = _recepinet.any((_d) => _d.wasRecentlyActive());
    String subTitle = "";
    if (_chat.messages.isNotEmpty) {
      subTitle =
          _chat.messages.first.type != MessagesType.TEXT
              ? "Media Attachment"
              : _chat.messages.first.content;
    }
    return CustomListView(
      onTap: () {
        print("Chat id is   ${_chat.uid}");
        _navigationService.navigateToPage(ChatsPage(chat: _chat));
      },
      height: _deviceHieght * 0.1,
      title: _chat.title(),
      subTitle: subTitle,
      isActive: _isActive,
      isActivity: _chat.activity,
      imagePath: _chat.imageURL(),
    );
  }
}
