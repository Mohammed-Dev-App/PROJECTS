import 'package:bucket_app/screen/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: {
      //   "home": (context) {
      //     return Mainscreen();
      //   },
      //   "add": (context) {
      //     return AddbuketScreen();
      //   },
      // },

      // initialRoute: "home",
      home: Mainscreen(),
    );
  }
}
