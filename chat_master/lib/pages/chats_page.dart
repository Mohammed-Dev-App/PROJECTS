import 'package:chat_master/provider/chats_page_provider.dart';
import 'package:chat_master/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Widget
import '../widget/top_bar.dart';
import '../widget/custom_list_view.dart';
import '../widget/custom_input_filed.dart';
//Models
import '../models/chat.dart';
import '../models/chat_masseges.dart';
//Provider
import '../provider/authentication_provider.dart';

class ChatsPage extends StatefulWidget {
  final Chat chat;
  ChatsPage({super.key, required this.chat});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ChatsPageProvider _chatsPageProvider;

  late NavigationService _navigationService;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;
  @override
  void initState() {
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create:
              (_) => ChatsPageProvider(
                widget.chat.uid,
                _auth,
                _messagesListViewController,
              ),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _chatsPageProvider = _context.watch<ChatsPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              height: _deviceHeight,
              width: _deviceWidth * 0.97,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TopBar(
                    fontsize: 18,
                    this.widget.chat.title(),
                    primaryAction: IconButton(
                      onPressed: () {
                        _chatsPageProvider.deleteChat();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {
                        _navigationService.goBack();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                  ),
                  _messagesListView(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (_chatsPageProvider.messages != null &&
        _chatsPageProvider.messages!.isNotEmpty) {
      return Container(
        height: _deviceHeight * 0.74,
        child: ListView.builder(
          controller: _messagesListViewController,
          itemCount: _chatsPageProvider.messages!.length,

          itemBuilder: (BuildContext context, int index) {
            ChatMessages _message = _chatsPageProvider.messages![index];
            bool isOwnMessage = _message.senderId == _auth.user.uid;
            print(isOwnMessage);

            return Container(
              // height: _deviceHeight * 0.74,
              padding: const EdgeInsets.all(2),
              child: CustomChatListView(
                deviceHieght: _deviceHeight,
                width: _deviceWidth * 0.80,
                message: _message,
                isOwnMessage: isOwnMessage,
                sender:
                    this.widget.chat.members
                        .where((e) => e.uid == _message.senderId)
                        .first,
              ),
            );
          },
        ),
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Text(
          "Be the first to say Hi",
          style: TextStyle(color: Colors.white54),
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      padding: EdgeInsets.only(right: 5),
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomInputFiled(
        onSaved: (value) {
          _chatsPageProvider.message = value;
        },
        regEx: r'^(?!\s*$).+',
        hintText: "Enter Message Text",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _chatsPageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
        icon: Icon(Icons.send, color: Colors.white),
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        onPressed: () {
          _chatsPageProvider.sendImageMessage();
        },

        icon: Icon(
          Icons.camera_alt_outlined,
          color: Color.fromRGBO(0, 82, 218, 1.0),
        ),
      ),
    );
  }
}
