import 'package:flutter/material.dart';
import 'package:youtube_app/models/video_model.dart';
import 'package:youtube_app/screens/home_page.dart';
import 'package:youtube_app/screens/page_not_found.dart';
import 'package:youtube_app/screens/short_video_page.dart';
import 'package:youtube_app/widgets/app_bar.dart';
import 'package:youtube_app/widgets/bottom_navigation_bar_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int selectedCategory = 0;
  bool isloading = true;
  bool isloadingMore = false;
  List<VideoModel> videos = [];
  int bottomBarSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YoutubeAppBar(),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          ShortVideoPage(),
          PageNotFound(),
          PageNotFound(),
          PageNotFound(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            bottomBarSelected = index;
          });
        },
        selected: bottomBarSelected,
      ),
    );
  }
}
