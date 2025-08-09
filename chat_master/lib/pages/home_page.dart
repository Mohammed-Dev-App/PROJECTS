import 'package:chat_master/pages/chat_page.dart';
import 'package:chat_master/pages/user_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [ChatPage(), UserPage()];
  @override
  Widget build(BuildContext context) {
    return _builUI();
  }

  Widget _builUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color.fromRGBO(232, 205, 175, .2),
        selectedItemColor: Color.fromRGBO(0, 82, 218, 1.0),
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(Icons.chat_bubble_sharp),
          ),
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(Icons.supervised_user_circle_sharp),
          ),
        ],
      ),
    );
  }
}
