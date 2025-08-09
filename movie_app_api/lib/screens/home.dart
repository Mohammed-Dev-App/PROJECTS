import 'package:flutter/material.dart';
import 'package:movie_app_api/screens/pages/home_page.dart';

import 'package:movie_app_api/screens/pages/movie_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController pageController = PageController(initialPage: 0);
  late int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          HomePage(),
          Center(child: MoviePage(title: 'Upcoming Movie')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blueGrey,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
            pageController.jumpToPage(value);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_outlined),
            label: "Movies",
          ),
        ],
      ),
    );
  }
}
