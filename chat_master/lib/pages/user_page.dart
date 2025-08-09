import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Provider
import '../provider/authentication_provider.dart';
import '../provider/user_page_provider.dart';

//Widget
import '../widget/top_bar.dart';
import '../widget/rounded_button.dart';
import '../widget/custom_input_filed.dart';
import '../widget/custom_list_view.dart';

//Model
import '../models/chat_user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UserPageProvider _userPageProvider;
  final TextEditingController _searchField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPageProvider>(
          create: (_) => UserPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (_context) {
        _userPageProvider = _context.watch<UserPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: _deviceHeight * 0.02,
            horizontal: _deviceWidth * 0.03,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                "Users",
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
              CustomTextField(
                onEditingComplete: (_value) {
                  _userPageProvider.getUsers(name: _value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search ...",
                obscureText: false,
                controller: _searchField,
                icon: Icons.search,
              ),
              _usersList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _usersList() {
    List<ChatUser>? _users = _userPageProvider.users;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.length != 0) {
            print(_users.length);
            return ListView.builder(
              itemCount: _users.length,

              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  child:
                      _users[index].uid != _auth.user.uid
                          ? CustomListViewTile(
                            height: _deviceHeight * 0.10,
                            title: _users[index].name,
                            subTitle:
                                'Last Active: ${_users[index].lastDayActive()}',
                            imagePath: _users[index].imageURL,

                            isActive: _users[index].wasRecentlyActive(),
                            isSelected: _userPageProvider.selectedUsers
                                .contains(_users[index]),
                            onTap: () {
                              _userPageProvider.updateSelectedUser(
                                _users[index],
                              );
                            },
                          )
                          : SizedBox.shrink(),
                );
              },
            );
          } else {
            return Text(
              "No Users Found.",
              style: TextStyle(color: Colors.white),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
      }(),
    );
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _userPageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name:
            _userPageProvider.selectedUsers.length == 1
                ? "Chat With ${_userPageProvider.selectedUsers.first.name}"
                : "Create Group Chat",
        hight: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPresses: () {
          _userPageProvider.createChat();
        },
      ),
    );
  }
}
