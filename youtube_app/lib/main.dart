import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:youtube_app/screens/channel_page.dart';
//import 'package:youtube_app/screens/home_page.dart';
import 'package:youtube_app/screens/main_screen.dart';
//import 'package:youtube_app/screens/search_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "M tube",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
      ),
      home: MainScreen(),
      // home: ChannelPage(channelId: "UCsQBsZJltmLzlsJNG7HevBg"),
      // home: SearchPage(),
    );
  }
}
